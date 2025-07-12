module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register implemented as shift register
    reg [1:0] state;

    // Feedback logic for next state
    wire feedback;
    assign feedback = (state[0] ^ in) | (state[1] & in);

    // State update with shift operation and async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;  // State A
        end else begin
            state <= {state[0], feedback};
        end
    end

    // Output is MSB (state D when state=2'b10)
    assign out = state[1] & ~state[0];

endmodule