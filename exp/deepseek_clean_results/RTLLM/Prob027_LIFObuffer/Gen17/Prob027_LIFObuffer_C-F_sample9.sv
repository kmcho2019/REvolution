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
    reg [1:0] SP;  // Stack pointer (points to next free slot)

    // Combinational outputs
    assign EMPTY = (state == EMPTY_ST);
    assign FULL = (state == FULL_ST);
    assign dataOut = (state != EMPTY_ST) ? stack_mem[SP] : 4'b0;

    // FSM and memory control
    always @(posedge Clk) begin
        if (Rst) begin
            state <= EMPTY_ST;
            SP <= 2'b00;
        end
        else if (EN) begin
            case (state)
                EMPTY_ST: begin
                    if (!RW) begin  // Write
                        stack_mem[0] <= dataIn;
                        SP <= 1;
                        state <= PARTIAL_ST;
                    end
                end
                
                PARTIAL_ST: begin
                    if (!RW && !FULL) begin  // Write
                        stack_mem[SP] <= dataIn;
                        SP <= SP + 1;
                        state <= (SP == 2'b10) ? FULL_ST : PARTIAL_ST;
                    end
                    else if (RW) begin  // Read
                        SP <= SP - 1;
                        state <= (SP == 2'b01) ? EMPTY_ST : PARTIAL_ST;
                    end
                end
                
                FULL_ST: begin
                    if (RW) begin  // Read
                        SP <= SP - 1;
                        state <= PARTIAL_ST;
                    end
                end
            endcase
        end
    end

endmodule