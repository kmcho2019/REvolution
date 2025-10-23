module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    wire a_is_min = (a <= b) & (a <= c) & (a <= d);
    wire b_is_min = (b <= a) & (b <= c) & (b <= d);
    wire c_is_min = (c <= a) & (c <= b) & (c <= d);
    wire d_is_min = (d <= a) & (d <= b) & (d <= c);

    always @(*) begin
        case ({a_is_min, b_is_min, c_is_min, d_is_min})
            4'b1000: min = a;
            4'b0100: min = b;
            4'b0010: min = c;
            4'b0001: min = d;
            default: min = a; // default case (shouldn't occur with distinct values)
        endcase
    end

endmodule