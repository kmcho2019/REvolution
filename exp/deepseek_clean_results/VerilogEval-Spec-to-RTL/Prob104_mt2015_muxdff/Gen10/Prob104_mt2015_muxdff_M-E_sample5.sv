module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire load_en = L;
    wire fb_en = ~L;
    wire effective_clk = clk & (load_en | fb_en);
    wire d = (load_en) ? r_in : q_in;

    always @(posedge effective_clk) begin
        Q <= d;
    end

endmodule