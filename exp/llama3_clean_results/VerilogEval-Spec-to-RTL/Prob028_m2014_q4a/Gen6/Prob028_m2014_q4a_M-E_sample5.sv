module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(d or ena) begin
    if (ena) begin
        q <= d; // Use non-blocking assignment for better synthesis
    end else begin
        // No need for an else, as q retains its value when ena is low
    end
end

endmodule