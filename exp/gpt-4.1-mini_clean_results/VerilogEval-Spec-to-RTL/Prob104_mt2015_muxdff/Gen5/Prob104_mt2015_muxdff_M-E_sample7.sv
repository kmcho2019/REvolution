module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire mux_out;

    // 2:1 multiplexer: if L=1 load r_in else load q_in
    assign mux_out = L ? r_in : q_in;

    // D flip-flop storing mux_out on rising clk edge
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule