module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

reg enable;

assign out_assign = enable? (a & b) : 1'b0;

always @(*) begin
    if (enable) begin
        out_alwaysblock = a & b;
    end else begin
        out_alwaysblock = 1'b0;
    end
end

// Generate the enable signal based on the inputs
assign enable = a | b;

endmodule