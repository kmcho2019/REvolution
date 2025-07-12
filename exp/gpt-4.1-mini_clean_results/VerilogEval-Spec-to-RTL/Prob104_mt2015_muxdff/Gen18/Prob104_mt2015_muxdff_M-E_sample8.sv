module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire mux_out;

    // 2:1 multiplexer selecting between r_in and q_in based on L
    assign mux_out = L ? r_in : q_in;

    // D Flip-Flop capturing mux_out on positive clock edge
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule