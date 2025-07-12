module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // To maintain the current state when ena is low, do nothing.
    end
end

endmodule