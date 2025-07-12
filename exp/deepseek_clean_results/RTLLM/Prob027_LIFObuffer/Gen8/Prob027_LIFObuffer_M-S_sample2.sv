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

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits for 0-3, plus empty state)
    reg [2:0] SP;  // [2] is empty flag, [1:0] is pointer

    // Combinational flags
    assign EMPTY = SP[2];
    assign FULL = (!SP[2] && (SP[1:0] == 2'b00));

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition: set empty flag
            SP <= 3'b100;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                if (EMPTY) begin
                    stack_mem[0] <= dataIn;
                    SP <= 3'b000;  // No longer empty, point to 0
                end
                else begin
                    stack_mem[SP[1:0]+1] <= dataIn;
                    SP <= SP + 1;
                end
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP[1:0]];
                if (SP[1:0] == 2'b00) begin
                    SP <= 3'b100;  // Set empty flag
                end
                else begin
                    SP <= SP - 1;
                end
            end
        end
    end

endmodule