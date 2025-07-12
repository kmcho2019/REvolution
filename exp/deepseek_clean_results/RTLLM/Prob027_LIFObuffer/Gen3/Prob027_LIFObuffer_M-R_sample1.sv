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

    reg [3:0] stack_mem [0:3];  // Stack memory
    reg [2:0] SP;               // Stack pointer (0-4)
    
    // Combinational outputs
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);
    
    // Stack operations
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset clears stack pointer only
            SP <= 3'd4;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b000: begin  // Write when not full
                    stack_mem[SP-1] <= dataIn;
                    SP <= SP - 1;
                end
                3'b110: begin  // Read when not empty
                    dataOut <= stack_mem[SP];
                    SP <= SP + 1;
                end
                default: ;  // No operation
            endcase
        end
    end

endmodule