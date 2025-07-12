module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire d;  // D input to the flip-flop after mux

    // 2:1 mux: if L=1, select r_in; else select q_in
    assign d = L ? r_in : q_in;

    // Flip-flop captures mux output at rising edge of clk
    always @(posedge clk) begin
        Q <= d;
    end

endmodule