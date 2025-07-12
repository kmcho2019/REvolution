module TopModule(
    input clock,
    input a,
    output reg p = 1'b0, // Initialize p to 0
    output reg q = 1'b0  // Initialize q to 0
);

always @(posedge clock) begin
    p <= a; // Update p on the positive edge of the clock based on a
end

always @(negedge clock) begin
    if (a) begin
        q <= 1'b0; // Reset q when a is high during the negative clock phase
    end else if (p) begin
        q <= 1'b1; // Set q when p is high and a is low during the negative clock phase
    end
end

endmodule