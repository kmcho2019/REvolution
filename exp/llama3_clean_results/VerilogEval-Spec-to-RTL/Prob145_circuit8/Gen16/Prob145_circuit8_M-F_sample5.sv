module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= 1; // Set p to 1 when a is high and clock is high
    end else begin
        p <= 0; // Set p to 0 otherwise
    end
end

always @(negedge clock) begin
    if (p) begin
        q <= 1; // Set q to 1 when p was high during the previous high clock phase
    end else begin
        q <= 0; // Set q to 0 otherwise
    end
end

initial begin
    p = 0; // Initialize p to 0
    q = 0; // Initialize q to 0
end

endmodule