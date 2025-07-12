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

    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (2 bits)
    reg [1:0] SP;

    // Combinational flag assignments
    assign EMPTY = (SP == 2'b00);
    assign FULL = (SP == 2'b11);

    always @(posedge Clk) begin
        if (Rst) begin
            SP <= 2'b00;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                SP <= SP - 1;
                dataOut <= stack_mem[SP - 1];
            end
        end
    end

endmodule