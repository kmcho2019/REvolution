module DFF_CE (
    input clk,
    input ce,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (ce)
            q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  L,
    input  q_in, // retained for interface; not used internally
    input  r_in,
    output Q
);

    // Using clock enable instead of mux: load r_in when L=1, else hold
    DFF_CE dff_ce_inst (
        .clk(clk),
        .ce(L),
        .d(r_in),
        .q(Q)
    );

endmodule