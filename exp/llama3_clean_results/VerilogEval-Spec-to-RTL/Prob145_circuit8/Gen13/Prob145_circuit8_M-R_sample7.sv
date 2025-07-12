module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a = 0; // Register to keep track of previous 'a'

always @(posedge clock) begin
    prev_a <= a; // Update prev_a on every clock cycle
end

assign p = clock && a; // p is 1 when clock and a are both high
assign q = (!clock && prev_a) || (clock && a); // q is 1 when clock is low and a was previously high, or when clock and a are both high

endmodule