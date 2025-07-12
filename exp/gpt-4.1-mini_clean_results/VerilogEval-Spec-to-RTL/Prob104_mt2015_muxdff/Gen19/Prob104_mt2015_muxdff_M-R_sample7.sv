module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire d;

    // 2:1 MUX: select r_in when L=1 else q_in
    assign d = L ? r_in : q_in;

    // D flip-flop capturing mux output on rising clk
    always @(posedge clk) begin
        Q <= d;
    end

endmodule