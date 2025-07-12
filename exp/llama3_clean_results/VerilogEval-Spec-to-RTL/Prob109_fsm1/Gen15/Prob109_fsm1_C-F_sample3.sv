module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)
    logic next_state; // Next state based on current state and input

    // Combinational logic for next state
    always @(*) begin
        case (state)
            0: next_state = in ? 0 : 1;
            1: next_state = in ? 1 : 0;
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Asynchronously reset to state B
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule