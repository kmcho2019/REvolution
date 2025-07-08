module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    wire mux_out;

    // 2:1 mux: if L=1 load r_in else keep q_in
    assign mux_out = L ? r_in : q_in;

    // Flip-flop with synchronous load
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule