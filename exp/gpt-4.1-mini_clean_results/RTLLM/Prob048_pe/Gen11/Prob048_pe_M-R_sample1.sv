module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // 64-bit accumulator register
    reg [63:0] acc;

    // Combinational 64-bit product
    wire [63:0] product;
    assign product = a * b;

    // Next state logic for accumulator
    reg [63:0] acc_next;
    always @(*) begin
        acc_next = acc + product;
    end

    // Sequential logic: register update with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc_next;
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc[31:0];

endmodule