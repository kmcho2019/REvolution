module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire do_update = L || E;  // Clock gating condition
wire next_Q = L ? R : w;  // Priority mux

always @(posedge clk) begin
    if (do_update) begin
        Q <= next_Q;
    end
    // else Q holds its value (implicit)
end

endmodule