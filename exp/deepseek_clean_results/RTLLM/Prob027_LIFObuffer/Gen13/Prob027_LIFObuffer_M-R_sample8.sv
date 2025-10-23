module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits)
    reg [1:0] SP;

    always @(posedge Clk) begin
        if (Rst) begin
            // Initialize stack pointer and clear first location
            SP <= 2'b00;
            stack_mem[0] <= 4'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            // Update flags
            EMPTY <= (SP == 2'b00);
            FULL <= (SP == 2'b11);

            case ({RW, FULL, EMPTY})
                3'b0_0_x: begin // Write when not full
                    stack_mem[SP] <= dataIn;
                    SP <= SP + 1;
                end
                3'b1_x_0: begin // Read when not empty
                    dataOut <= stack_mem[SP-1];
                    SP <= SP - 1;
                end
                default: ; // No operation
            endcase
        end
    end

    // Initial flag values
    initial begin
        EMPTY = 1'b1;
        FULL = 1'b0;
    end

endmodule