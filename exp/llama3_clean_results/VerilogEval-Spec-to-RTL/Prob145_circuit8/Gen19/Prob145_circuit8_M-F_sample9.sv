module TopModule(
    input  logic clock,
    input  logic a,
    output logic p,
    output logic q
);

always_ff @(posedge clock) begin
    p <= a; // Update p based on a when clock is high
end

always_ff @(negedge clock) begin
    q <= p; // Update q based on the previous value of p when clock is low
end

// Initialize p and q to 0 when clock is low
initial begin
    p = 0;
    q = 0;
end

endmodule