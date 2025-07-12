module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d;
    end else begin
        // Do nothing to keep the current value of q when ena is low
    end
end

endmodule