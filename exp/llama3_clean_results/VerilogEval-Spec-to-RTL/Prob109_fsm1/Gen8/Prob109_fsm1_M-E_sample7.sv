module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic [1:0] state; // Current state (A=0, B=1)
    logic [1:0] next_state; // Next state
    logic [1:0] out_val; // Output value

    // Define the lookup table for next state and output
    always_comb begin
        case ({state, in})
            2'b00: {next_state, out_val} = 2'b10; // A, in=0 -> B, out=1
            2'b01: {next_state, out_val} = 2'b00; // A, in=1 -> A, out=0
            2'b10: {next_state, out_val} = 2'b11; // B, in=0 -> B, out=1
            2'b11: {next_state, out_val} = 2'b11; // B, in=1 -> B, out=1
            default: {next_state, out_val} = 2'b11; // Default to B, out=1
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Asynchronously reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Directly assign output based on the state and LUT
    assign out = out_val;

endmodule