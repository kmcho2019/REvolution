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

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0-4)
    reg [2:0] SP;
    
    // Combinational outputs
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);
    assign dataOut = stack_mem[SP];
    
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 3'd4;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (EN) begin
            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin // Write when not full
                    stack_mem[SP-1] <= dataIn;
                    SP <= SP - 1;
                end
                3'b1_x_0: begin // Read when not empty
                    SP <= SP + 1;
                end
                default: ; // No operation
            endcase
        end
    end

endmodule