module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// p is high when both clock and a are high
assign p = clock & a;

// q remembers p from previous clock high phase
always @(negedge clock) begin
    if (a) begin
        q <= p;  // Capture p's value at clock high
    end else begin
        q <= 1'b0;  // Clear when a is low during clock low
    end
end

endmodule