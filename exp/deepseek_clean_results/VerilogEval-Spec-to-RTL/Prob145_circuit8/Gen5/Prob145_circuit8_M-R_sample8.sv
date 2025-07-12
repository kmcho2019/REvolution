module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg prev_p;

// State update (sequential)
always @(posedge clock) begin
    prev_p <= p;  // Store p's value for next cycle
end

// Output logic (combinational)
assign p = a & ~prev_p;  // p is high when a is high and prev_p was low
assign q = prev_p;       // q follows previous p value

endmodule