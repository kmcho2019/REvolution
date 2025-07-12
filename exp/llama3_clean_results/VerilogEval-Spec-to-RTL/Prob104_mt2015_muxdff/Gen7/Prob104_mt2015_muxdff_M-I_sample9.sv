module TopModule (
    input  clk,
    input  L,
    input  q_in,  // Feedback from the previous flip-flop in the chain
    input  r_in,
    output reg Q
);

    // 2:1 Multiplexer
    assign selected_input = L ? r_in : q_in;

    // Flip-flop
    always @(posedge clk) begin
        Q <= selected_input;
    end

endmodule