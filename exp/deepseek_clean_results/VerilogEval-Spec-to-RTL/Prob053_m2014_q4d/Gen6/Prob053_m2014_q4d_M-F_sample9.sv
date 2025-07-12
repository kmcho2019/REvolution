module TopModule (
    input clk,
    input in,
    output out
);

    // Feedback path through XOR
    wire feedback;
    assign feedback = in ^ out;

    // Flip-flop with feedback as input, initialized to 0
    reg state = 1'b0;
    assign out = state;

    always @(posedge clk) begin
        state <= feedback;
    end

endmodule