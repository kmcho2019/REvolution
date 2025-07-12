module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)
    logic next_state; // Next state

    // Look-up table for next state and output
    always_comb begin
        case ({state, in})
            2'b00: {next_state, out} = 2'b10; // A, in=0 -> B, out=1
            2'b01: {next_state, out} = 2'b00; // A, in=1 -> A, out=0
            2'b10: {next_state, out} = 2'b11; // B, in=0 -> B, out=1
            2'b11: {next_state, out} = 2'b01; // B, in=1 -> B, out=1
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

endmodule