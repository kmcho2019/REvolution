module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_clock;

always @(posedge clock or negedge clock) begin
    if (clock) begin // Positive clock edge
        if (a) begin
            p <= 1;
        end else begin
            p <= 0;
        end
    end else begin // Negative clock edge
        if (a) begin
            q <= p;
        end
    end
    prev_clock <= clock; // For reference, not needed here but useful for other designs
end

endmodule