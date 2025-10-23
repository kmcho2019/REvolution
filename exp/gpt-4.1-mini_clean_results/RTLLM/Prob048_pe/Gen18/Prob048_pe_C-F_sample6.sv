module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // 64-bit accumulator register
    reg [63:0] acc;
    reg        saturated;

    // 64-bit product of inputs
    wire [63:0] product;
    assign product = a * b;

    // Next accumulator value
    wire [63:0] acc_next = acc + product;

    // Detect if next lower 32 bits exceed 32'hFFFFFFFF or overflow beyond 32 bits
    // Overflow defined as next acc value exceeding 32'hFFFFFFFF in lower 32 bits or high bits non-zero
    wire overflow = (acc_next[63:32] != 0) || (acc_next[31:0] > 32'hFFFF_FFFF);

    // Sequential logic: update accumulator and saturation flag
    always @(posedge clk) begin
        if (rst) begin
            acc       <= 64'd0;
            saturated <= 1'b0;
        end else if (saturated) begin
            // Once saturated, hold max value to prevent wrap-around
            acc       <= {32'd0, 32'hFFFF_FFFF};
            saturated <= 1'b1;
        end else if (overflow) begin
            // Saturate accumulator to max 32-bit unsigned value in lower bits
            acc       <= {32'd0, 32'hFFFF_FFFF};
            saturated <= 1'b1;
        end else begin
            acc       <= acc_next;
            saturated <= 1'b0;
        end
    end

    // Output lower 32 bits of accumulator (saturated if overflow)
    assign c = acc[31:0];

endmodule