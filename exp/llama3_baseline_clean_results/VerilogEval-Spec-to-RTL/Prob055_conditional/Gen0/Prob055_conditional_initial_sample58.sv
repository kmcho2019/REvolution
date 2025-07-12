module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    always @(*) begin
        if (b < a) begin
            min = (c < b) ? (d < c ? d : c) : (d < b ? d : b);
        end else begin
            min = (c < a) ? (d < c ? d : c) : (d < a ? d : a);
        end
    end

endmodule