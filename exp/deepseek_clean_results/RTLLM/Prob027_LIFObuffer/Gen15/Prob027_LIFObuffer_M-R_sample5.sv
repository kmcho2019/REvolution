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

    // FSM states
    localparam EMPTY_ST = 2'b00;
    localparam PARTIAL_ST = 2'b01;
    localparam FULL_ST = 2'b10;
    
    reg [1:0] state;
    reg [1:0] SP;  // Stack pointer
    reg [3:0] stack_mem [0:3];
    
    // Combinational outputs
    assign EMPTY = (state == EMPTY_ST);
    assign FULL = (state == FULL_ST);
    assign dataOut = stack_mem[SP];
    
    // FSM and memory control
    always @(posedge Clk) begin
        if (Rst) begin
            state <= EMPTY_ST;
            SP <= 2'b00;
            stack_mem[0] <= 4'b0;  // Only initialize first location
        end
        else if (EN) begin
            case (state)
                EMPTY_ST: begin
                    if (!RW) begin  // Write
                        stack_mem[0] <= dataIn;
                        state <= PARTIAL_ST;
                    end
                end
                
                PARTIAL_ST: begin
                    if (!RW && !FULL) begin  // Write
                        if (SP == 2'b10) state <= FULL_ST;
                        SP <= SP + 1;
                        stack_mem[SP + 1] <= dataIn;
                    end
                    else if (RW) begin  // Read
                        if (SP == 2'b00) state <= EMPTY_ST;
                        SP <= SP - 1;
                    end
                end
                
                FULL_ST: begin
                    if (RW) begin  // Read
                        state <= PARTIAL_ST;
                        SP <= SP - 1;
                    end
                end
            endcase
        end
    end

endmodule