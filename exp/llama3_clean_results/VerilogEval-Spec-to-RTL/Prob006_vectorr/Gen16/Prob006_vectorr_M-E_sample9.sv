// Parameterized module to reverse the bit ordering of a vector using a shift register
module TopModule #(
    parameter WIDTH = 8 // Parameter for the width of the input vector
)(
    input  clk, // Clock signal
    input  rst_n, // Active low reset signal
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector
);
    reg [WIDTH-1:0] shift_reg; // Shift register
    reg [WIDTH-1:0] out_reg; // Output register

    // Clock in the input bits
    always @(posedge clk) begin
        if (~rst_n) begin
            shift_reg <= 0;
        end else begin
            shift_reg <= {in[WIDTH-1], shift_reg[WIDTH-1:1]};
        end
    end

    // Shift out the output bits
    always @(posedge clk) begin
        if (~rst_n) begin
            out_reg <= 0;
        end else if (shift_reg[0] == 1'b1) begin
            out_reg <= {shift_reg[WIDTH-1:1], 1'b0};
        end else begin
            out_reg <= shift_reg;
        end
    end

    // Assign the output
    assign out = out_reg;
endmodule