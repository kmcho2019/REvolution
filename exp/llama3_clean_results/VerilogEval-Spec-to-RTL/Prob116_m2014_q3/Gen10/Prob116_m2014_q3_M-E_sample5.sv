module TopModule(
    input [3:0] x,
    output logic f
);

always @(*) begin
    if (x[3] == 1'b1) begin
        f = ~(x[2] && x[1]) ? 1'b1 : (x[2] && x[1]);
    end else begin
        f = x[2] && x[1];
    end
end

endmodule