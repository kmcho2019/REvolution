module TopModule(
    input clock,
    input a,
    output reg p = 0,
    output reg q = 0
);

reg prev_p = 0; // Previous state of p

always @(posedge clock) begin
    if (a) begin
        p <= 1;
        prev_p <= 1; // Set prev_p to 1 when a is high
    end else begin
        p <= 0;
    end
end

always @(negedge clock) begin
    if (prev_p) begin
        q <= 1; // Set q to 1 if prev_p is 1
    end else if (a) begin
        q <= 0; // Reset q if a is high on low clock phase
    end
end

endmodule