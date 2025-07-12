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

    // Stack memory as packed array (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (3 bits, with 4'b1111 representing empty state)
    reg [2:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 3'b111);
    assign FULL = (SP == 3'b011);  // SP at max capacity (3)

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset to empty state
            SP <= 3'b111;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP[1:0]] <= dataIn;
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[SP[1:0] - 1'b1];
                SP <= SP - 1;
            end
        end
    end

endmodule