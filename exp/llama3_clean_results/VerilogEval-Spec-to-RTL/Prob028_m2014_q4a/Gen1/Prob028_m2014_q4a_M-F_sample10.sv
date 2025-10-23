module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q = d;
    end else begin
        // do nothing, q retains its previous value
    end
end

endmodule