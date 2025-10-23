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
    reg [2:0] SP;  // Stack pointer (0=empty, 4=full)
    
    // Combinational outputs
    assign EMPTY = (SP == 0);
    assign FULL = (SP == 4);
    assign dataOut = (SP > 0) ? stack_mem[SP-1] : 4'b0;
    
    // Stack operations
    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin  // Write when not full
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                3'b1_x_0: begin  // Read when not empty
                    SP <= SP - 1;
                end
                default: ;  // No operation
            endcase
        end
    end

endmodule