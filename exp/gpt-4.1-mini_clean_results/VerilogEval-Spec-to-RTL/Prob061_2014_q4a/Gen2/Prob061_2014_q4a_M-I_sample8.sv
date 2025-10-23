module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);
    wire ce = L | E;
    wire d = L ? R : w;

    always @(posedge clk) begin
        if (ce)
            Q <= d;
    end
endmodule