module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // Variable to store the previous state of 'a'

always @(posedge clock or negedge clock) begin
    // At the positive edge of the clock, update 'p' based on 'a'
    if (clock) begin
        p <= a;
        // If 'p' is high, set 'q' high
        if (a) begin
            q <= 1'b1;
        end
    // At the negative edge of the clock, check if 'a' has gone low
    end else if (!a && prev_a) begin
        // If 'a' has gone low, reset 'q' to low
        q <= 1'b0;
    end
    // Update the previous state of 'a'
    prev_a <= a;
end

endmodule