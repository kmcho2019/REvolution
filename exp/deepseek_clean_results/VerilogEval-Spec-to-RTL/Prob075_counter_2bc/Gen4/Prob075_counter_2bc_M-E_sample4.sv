module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] delta = {2{train_valid}} & (train_taken ? 2'b01 : 2'b11);
wire [1:0] next_state_unsat = state + delta;
wire [1:0] next_state;

// Saturation logic
assign next_state = (train_taken & (&state)) ? state :        // Max check (3)
                   (~train_taken & ~(|state)) ? state :       // Min check (0)
                   next_state_unsat;                          // Normal case

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else begin
        state <= next_state;
    end
end

endmodule