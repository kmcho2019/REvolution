module TopModule(
    input  logic clock,
    input  logic a,
    output logic p,
    output logic q
);

always_ff @(posedge clock) begin
    if (a) begin
        p <= 1; // Update p to 1 when clock is high and a is 1
    end else begin
        p <= 0; // Update p to 0 when clock is high and a is 0
    end
end

always_ff @(negedge clock) begin
    if (p) begin
        q <= 1; // Update q to 1 when clock is low and p is 1
    end else begin
        q <= 0; // Update q to 0 when clock is low and p is 0
    end
end

endmodule