module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire mux_sel;

    // 2:1 multiplexer output
    assign mux_sel = (L) ? r_in : q_in;

    // D flip-flop capturing mux_sel at posedge clk
    always @(posedge clk) begin
        Q <= mux_sel;
    end

    // Initialize Q to zero to prevent unknown startup state
    initial begin
        Q = 1'b0;
    end

endmodule