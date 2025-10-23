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
    parameter PTR_WIDTH = $clog2(DEPTH+1);
    
    // Stack memory array
    reg [3:0] stack_mem [0:DEPTH-1];
    // Stack pointer (0 to DEPTH)
    reg [PTR_WIDTH-1:0] SP;

    // Continuous assignments for flags
    assign EMPTY = (SP == DEPTH);
    assign FULL = (SP == 0);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset stack pointer only - memory doesn't need initialization
            SP <= DEPTH;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin // Write when not full
                    stack_mem[SP-1] <= dataIn;
                    SP <= SP - 1;
                end
                3'b1_x_0: begin // Read when not empty
                    dataOut <= stack_mem[SP];
                    SP <= SP + 1;
                end
                default: ; // No operation
            endcase
        end
    end

endmodule