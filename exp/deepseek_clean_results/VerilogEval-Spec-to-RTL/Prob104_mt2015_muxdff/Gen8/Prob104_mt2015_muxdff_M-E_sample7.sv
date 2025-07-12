module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire clk_enable = L || (q_in != Q);  // Clock gating condition
    wire gated_clk = clk & clk_enable;

    always @(posedge gated_clk) begin
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= q_in;
        end
    end

endmodule