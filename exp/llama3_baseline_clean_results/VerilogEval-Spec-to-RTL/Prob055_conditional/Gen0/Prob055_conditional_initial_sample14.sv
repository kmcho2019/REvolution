module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    always @(*) begin
        if (a < b) begin
            min = (a < c) ? (a < d ? a : d) : (c < d ? c : d);
        end else begin
            min = (b < c) ? (b < d ? b : d) : (c < d ? c : d);
        end
    end

endmodule