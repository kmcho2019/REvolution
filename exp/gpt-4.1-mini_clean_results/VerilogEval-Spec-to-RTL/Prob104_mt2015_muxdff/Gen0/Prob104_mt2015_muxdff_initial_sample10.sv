module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    wire mux_out;

    // 2:1 multiplexer: if L=1 select r_in else q_in
    assign mux_out = L ? r_in : q_in;

    // Flip-flop capturing mux_out on rising edge of clk
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule