module TopModule (
    input d,
    input ena,
    output reg q
);

// D latch implementation
always @(d or ena) begin
    if (ena) begin
        q <= d;
    end
    // q retains value when ena is low (implied latch behavior)
end

endmodule