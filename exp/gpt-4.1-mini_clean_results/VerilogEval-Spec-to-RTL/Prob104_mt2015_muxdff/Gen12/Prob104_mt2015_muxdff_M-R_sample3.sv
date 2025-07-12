module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output Q
);
    wire mux_out;

    // 2:1 Mux: if L=1 load r_in, else load q_in
    assign mux_out = L ? r_in : q_in;

    DFF dff_inst (
        .clk(clk),
        .d(mux_out),
        .q(Q)
    );

endmodule