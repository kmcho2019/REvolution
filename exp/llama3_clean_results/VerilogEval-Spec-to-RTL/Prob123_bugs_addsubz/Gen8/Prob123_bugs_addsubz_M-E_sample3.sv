module adder_subtractor #
(
    parameter WIDTH = 8
)
(
    input logic clk,
    input logic do_sub,
    input logic [WIDTH-1:0] a,
    input logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out,
    output logic result_is_zero
);

    // Multiplexer to select between normal input and inverted input plus one
    wire [WIDTH-1:0] b_selector;
    assign b_selector = do_sub ? (~b + 1) : b;

    // Full adder to perform addition or subtraction
    wire [WIDTH-1:0] sum;
    assign sum = a + b_selector;

    // Zero detection circuit using bitwise NOR operation
    wire is_zero;
    assign is_zero = ~(| sum);

    // Clock-gating to reduce power consumption
    reg [WIDTH-1:0] out_reg;
    reg result_is_zero_reg;
    always @(posedge clk) begin
        out_reg <= sum;
        result_is_zero_reg <= is_zero;
    end

    assign out = out_reg;
    assign result_is_zero = result_is_zero_reg;

endmodule

// Top-level module
module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Instantiate adder_subtractor module with width parameter
    adder_subtractor #(.WIDTH(8)) u_adder_subtractor (
        .clk(1'b1), // Assuming a constant clock signal
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule