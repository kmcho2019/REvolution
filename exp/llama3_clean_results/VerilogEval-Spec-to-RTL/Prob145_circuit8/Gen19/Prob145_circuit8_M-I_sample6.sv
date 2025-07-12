module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a; // To store the previous value of 'a'

always @(posedge clock) begin
    prev_a <= a; // Update the previous value of 'a'
    p <= a; // 'p' is high only when 'a' is high
    if (a && prev_a) begin // 'a' has been high for two clock cycles
        q <= 1'b1; // Set 'q' high
    end else if (!a) begin
        q <= 1'b0; // Reset 'q' if 'a' is low
    end
end

always @(negedge clock) begin
    if (q) begin // If 'q' is already high
        q <= 1'b1; // Keep 'q' high
    end
end

initial begin
    prev_a = 1'b0; // Initialize 'prev_a' to 0
    p = 1'b0; // Initialize 'p' to 0
    q = 1'b0; // Initialize 'q' to 0
end

endmodule