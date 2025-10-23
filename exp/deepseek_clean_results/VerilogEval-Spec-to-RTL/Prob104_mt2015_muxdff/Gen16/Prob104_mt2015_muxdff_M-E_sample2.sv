module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire mux_out;
    wire not_L;
    wire and_q, and_r;

    // 2:1 MUX implementation
    not(not_L, L);
    and(and_q, q_in, not_L);
    and(and_r, r_in, L);
    or(mux_out, and_q, and_r);

    // D Flip-Flop
    dff dff_inst (
        .d(mux_out),
        .clk(clk),
        .q(Q)
    );

endmodule

// Basic D Flip-Flop module
module dff (
    input d,
    input clk,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule