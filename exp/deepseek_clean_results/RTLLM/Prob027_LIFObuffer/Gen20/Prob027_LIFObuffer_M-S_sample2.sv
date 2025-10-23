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

    // Stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0=empty, 1-4=entries)
    reg [2:0] ptr;

    // Flag assignments
    assign EMPTY = (ptr == 3'b000);
    assign FULL = (ptr == 3'b100);

    always @(posedge Clk) begin
        if (Rst) begin
            ptr <= 3'b000;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                stack_mem[ptr] <= dataIn;
                ptr <= ptr + 1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= stack_mem[ptr-1];
                ptr <= ptr - 1;
            end
        end
    end

endmodule