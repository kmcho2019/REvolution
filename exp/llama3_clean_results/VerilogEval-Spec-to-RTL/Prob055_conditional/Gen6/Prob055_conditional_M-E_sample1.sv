module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    wire a_smaller_b, a_smaller_c, a_smaller_d;
    wire b_smaller_c, b_smaller_d;
    wire c_smaller_d;

    // Comparisons
    assign a_smaller_b = (a < b);
    assign a_smaller_c = (a < c);
    assign a_smaller_d = (a < d);
    assign b_smaller_c = (b < c);
    assign b_smaller_d = (b < d);
    assign c_smaller_d = (c < d);

    // Priority Encoder Logic
    always @(*) begin
        if (a_smaller_b && a_smaller_c && a_smaller_d) begin
            min = a;
        end else if (b_smaller_a && b_smaller_c && b_smaller_d) begin
            min = b;
        end else if (c_smaller_a && c_smaller_b && c_smaller_d) begin
            min = c;
        end else begin
            min = d;
        end
    end

    // Helper wires for the "else if" conditions
    wire b_smaller_a, c_smaller_a, c_smaller_b, d_smaller_a, d_smaller_b, d_smaller_c;
    assign b_smaller_a = (b < a);
    assign c_smaller_a = (c < a);
    assign c_smaller_b = (c < b);
    assign d_smaller_a = (d < a);
    assign d_smaller_b = (d < b);
    assign d_smaller_c = (d < c);

endmodule