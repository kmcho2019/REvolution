module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    wire ce = L | E;          // Clock enable: update only on load or shift
    wire d = L ? R : w;       // Select load value R or shifted-in value w

    always @(posedge clk) begin
        if (ce)
            Q <= d;
        // else retain Q (no change)
    end

endmodule