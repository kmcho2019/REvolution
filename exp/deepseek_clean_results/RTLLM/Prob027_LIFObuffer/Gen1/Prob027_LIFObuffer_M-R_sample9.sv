module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    parameter DEPTH = 4;
    reg [3:0] stack_mem [0:DEPTH-1];
    reg [2:0] SP;  // 0:DEPTH (0-full, DEPTH-empty)

    // Continuous flag assignments
    assign EMPTY = (SP == DEPTH);
    assign FULL = (SP == 0);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= DEPTH;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin  // Write when not full
                    stack_mem[SP-1] <= dataIn;
                    SP <= SP - 1;
                end
                3'b1_x_0: begin  // Read when not empty
                    dataOut <= stack_mem[SP];
                    SP <= SP + 1;
                end
                default: ;  // No operation
            endcase
        end
    end

endmodule