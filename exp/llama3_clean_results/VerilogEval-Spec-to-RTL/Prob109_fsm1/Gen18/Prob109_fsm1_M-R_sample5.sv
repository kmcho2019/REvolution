module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)
    logic next_state; // Next state

    // Combinational logic to determine the next state
    always_comb begin
        case (state)
            1'b0: next_state = in ? 1'b0 : 1'b1;
            1'b1: next_state = in ? 1'b1 : 1'b0;
            default: next_state = 1'b1; // Default to state B
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Asynchronously reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule