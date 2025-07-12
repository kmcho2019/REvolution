module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a = 0; // Register to keep track of previous 'a'

always @(posedge clock or negedge clock) begin
    if (!clock && !a) // Reset prev_a when clock is low and a is low
        prev_a <= 0;
    else if (clock && a) // Set prev_a when clock is high and a is high
        prev_a <= 1;
end

always @(*) begin
    p = clock && a; // 'p' is high when both 'clock' and 'a' are high
    q = prev_a; // 'q' is high if 'a' was previously high
end

endmodule