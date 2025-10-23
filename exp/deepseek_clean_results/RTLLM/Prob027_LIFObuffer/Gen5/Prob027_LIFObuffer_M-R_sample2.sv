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

    // Internal stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (3 bits: [2] unused, [1:0] for index, 0 means empty)
    reg [2:0] SP;
    
    // Combinational outputs
    assign EMPTY = (SP == 3'b000);
    assign FULL = (SP == 3'b100);
    assign dataOut = stack_mem[SP[1:0] - 1]; // Current top of stack

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition - only clear pointer
            SP <= 3'b000;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin // Push when not full
                    stack_mem[SP[1:0]] <= dataIn;
                    SP <= SP + 1;
                end
                3'b1_x_0: begin // Pop when not empty
                    SP <= SP - 1;
                end
                default: ; // No operation
            endcase
        end
    end

endmodule