module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic [1:0] state; // Current state in one-hot encoding (A=01, B=10)
    logic [1:0] next_state; // Next state based on current state and input

    // Combinational logic for next state using one-hot encoding
    always @(*) begin
        case (1'b1)
            state[0]: next_state = in? {1'b0, 1'b1} : {1'b1, 1'b0}; // State A
            state[1]: next_state = in? {1'b1, 1'b0} : {1'b0, 1'b1}; // State B
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b10; // Asynchronously reset to state B (one-hot)
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // Directly assign output based on the state (one-hot)
    assign out = state[1]; // Output corresponds to State B in one-hot encoding

endmodule