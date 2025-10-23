module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg full_p;  // Indicates p was high for full previous cycle
reg prev_a;  // Stores previous a value for edge detection

always @(posedge clock) begin
    // Update p based on current state
    if (!q) begin
        p <= a;
    end else begin
        p <= 0;
    end

    // Check if p was high for full previous cycle
    full_p <= p && prev_a;

    // Update q based on full cycle observation
    if (full_p) begin
        q <= 1;
    end

    // Reset condition (simplified synchronous version)
    if (a) begin
        q <= 0;
    end

    prev_a <= a;
end

initial begin
    p = 0;
    q = 0;
    full_p = 0;
    prev_a = 0;
end

endmodule