module TopModule(
    input clock,
    input a,
    output reg p = 0,
    output reg q = 0
);

always @(posedge clock) begin
    if (a) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

always @(negedge clock) begin
    if (a) begin
        q <= 0; // Reset q if a is high on low clock phase
    end else if (p) begin // If p was high on previous high clock phase
        q <= 1; // Set q high
    end
end

endmodule