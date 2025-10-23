module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output wire [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // FSM states
    localparam EMPTY_ST  = 2'b00;
    localparam PARTIAL_ST = 2'b01;
    localparam FULL_ST   = 2'b10;
    
    reg [1:0] state;
    reg [1:0] SP_gray;  // Gray-coded stack pointer

    // Gray code conversions
    wire [1:0] SP_bin = {SP_gray[1], SP_gray[1] ^ SP_gray[0]};
    wire [1:0] next_SP_gray;

    // Combinational outputs
    assign EMPTY = (state == EMPTY_ST);
    assign FULL = (state == FULL_ST);
    assign dataOut = stack_mem[SP_bin];  // Combinational read

    // Gray code increment/decrement
    assign next_SP_gray = (!RW && !FULL) ? {SP_gray[1], ~SP_gray[0]} :  // Gray increment
                         (RW && !EMPTY) ? {~SP_gray[1], SP_gray[0]} :   // Gray decrement
                         SP_gray;

    // FSM and memory control
    always @(posedge Clk) begin
        if (Rst) begin
            state <= EMPTY_ST;
            SP_gray <= 2'b00;
        end
        else if (EN) begin
            case (state)
                EMPTY_ST: begin
                    if (!RW) begin  // Write
                        stack_mem[0] <= dataIn;
                        SP_gray <= 2'b01;  // Gray code for 1
                        state <= (1 == 3) ? FULL_ST : PARTIAL_ST;
                    end
                end
                
                PARTIAL_ST: begin
                    if (!RW && !FULL) begin  // Write
                        stack_mem[SP_bin + 1] <= dataIn;
                        SP_gray <= next_SP_gray;
                        if (SP_bin == 2'b10) state <= FULL_ST;  // About to become full
                    end
                    else if (RW) begin  // Read
                        SP_gray <= next_SP_gray;
                        if (SP_bin == 1) state <= EMPTY_ST;
                    end
                end
                
                FULL_ST: begin
                    if (RW) begin  // Read
                        SP_gray <= next_SP_gray;
                        state <= PARTIAL_ST;
                    end
                end
            endcase
        end
    end

endmodule