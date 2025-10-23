module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(*) begin
    if (ena) begin
        q = d; // Using blocking assignment for clarity in a level-sensitive latch
    end else begin
        q = q; // Explicitly keeping the value of q when ena is low
    end
end

endmodule