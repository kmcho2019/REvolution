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

    // Packed stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    
    // Gray-coded stack pointer (2 bits)
    reg [1:0] SP_gray;
    wire [1:0] SP_bin = {SP_gray[1], SP_gray[1] ^ SP_gray[0]};
    
    // FSM states
    localparam EMPTY_ST  = 2'b00;
    localparam PARTIAL_ST = 2'b01;
    localparam FULL_ST   = 2'b10;
    
    reg [1:0] state;

    // Combinational outputs
    assign EMPTY = (state == EMPTY_ST);
    assign FULL = (state == FULL_ST);
    assign dataOut = stack_mem[SP_bin];  // Always shows top of stack

    // Gray code increment/decrement functions
    function [1:0] gray_inc;
        input [1:0] gray;
        begin
            gray_inc = gray ^ {1'b0, &gray};
        end
    endfunction

    function [1:0] gray_dec;
        input [1:0] gray;
        begin
            gray_dec = gray ^ {1'b0, |(~gray)};
        end
    endfunction

    // FSM and memory control
    always @(posedge Clk) begin
        if (Rst) begin
            state <= EMPTY_ST;
            SP_gray <= 2'b00;
            stack_mem[0] <= 4'b0;  // Only clear first location
        end
        else if (EN) begin
            case (state)
                EMPTY_ST: begin
                    if (!RW) begin  // Write
                        stack_mem[0] <= dataIn;
                        SP_gray <= 2'b01;  // Binary 1
                        state <= PARTIAL_ST;
                    end
                end
                
                PARTIAL_ST: begin
                    if (!RW && !FULL) begin  // Write
                        stack_mem[SP_bin + 1] <= dataIn;
                        SP_gray <= gray_inc(SP_gray);
                        if (SP_bin == 2'b10) state <= FULL_ST;  // About to become full
                    end
                    else if (RW) begin  // Read
                        SP_gray <= gray_dec(SP_gray);
                        if (SP_bin == 2'b01) state <= EMPTY_ST;  // About to become empty
                    end
                end
                
                FULL_ST: begin
                    if (RW) begin  // Read
                        SP_gray <= gray_dec(SP_gray);
                        state <= PARTIAL_ST;
                    end
                end
            endcase
        end
    end

endmodule