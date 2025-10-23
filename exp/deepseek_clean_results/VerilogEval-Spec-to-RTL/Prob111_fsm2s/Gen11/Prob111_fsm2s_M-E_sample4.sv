module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg [1:0] state_reg;  // [next_state, current_state]

    // Feedback logic for next state
    wire next_state = (state_reg[0] ? ~k : j) & ~reset;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'b00;
        end else begin
            state_reg <= {next_state, state_reg[1]};
        end
    end

    assign out = state_reg[0];

endmodule