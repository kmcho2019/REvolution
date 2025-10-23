module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire selected_input;

    // 2:1 Multiplexer
    assign selected_input = L? r_in : q_in;

    // Flip-flop
    always @(posedge clk) begin
        Q <= selected_input;
    end

endmodule