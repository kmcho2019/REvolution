module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg [1:0] state;  // one-hot: state[0]=A, state[1]=B

    // Next state logic
    wire next_A = state[0] & ~x;
    wire next_B = (state[0] & x) | state[1];

    // Output logic
    assign z = (state[0] & x) | (state[1] & ~x);

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A (01)
        end else begin
            state <= {next_B, next_A};
        end
    end

endmodule