module TopModule(
    input clock,
    input a,
    output reg p = 1'b0,
    output reg q = 1'b0
);

always @(posedge clock) begin
    p <= a; // Update p based on a during positive clock phase
    if (a) begin
        q <= 1'b1; // Set q high when a is high during positive clock phase
    end else if (q) begin
        q <= 1'b1; // Keep q high if it was already set
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 1'b0; // Reset q when a is high during low clock phase
    end
end

endmodule