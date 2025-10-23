module TopModule(
    input  d,
    input  ena,
    output reg q
);
// Using an always block to implement the D latch behavior
always @(d, ena) begin
    if (ena) begin
        // When ena is high, assign the value of d to q
        q = d;
    end else begin
        // When ena is low, retain the previous state of q
        q = q;
    end
end

endmodule