module pe (
    input           clk,
    input           rst,
    input           en,        // clock enable to gate accumulation (added for power optimization)
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [63:0] accumulator;
    wire [63:0] product;

    assign product = a * b;
    assign c = accumulator[31:0];  // output lower 32 bits

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else if (en) begin
            accumulator <= accumulator + product;
        end
        // if en=0, retain current accumulator value (no accumulation)
    end

endmodule