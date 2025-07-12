module TopModule(
    input  logic clock,
    input  logic a,
    output logic p,
    output logic q
);

always_ff @(posedge clock) begin
    p <= a; // Update p based on a
end

always_ff @(negedge clock) begin
    q <= p; // Update q based on the previous value of p
end

endmodule