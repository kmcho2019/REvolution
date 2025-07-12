module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output logic q
);

always_comb begin
    if (a == 1'b1) begin
        q = 1'b1;
    end else begin
        q = b || c;
    end
end

endmodule