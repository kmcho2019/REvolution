module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;

    // Combinational logic: compute next_state with saturating increment/decrement
    always @(*) begin
        if (train_valid) begin
            next_state = train_taken ?
                         ((state == 2'b11) ? 2'b11 : state + 1'b1) :
                         ((state == 2'b00) ? 2'b00 : state - 1'b1);
        end else begin
            next_state = state; // Hold state when not training
        end
    end

    // Sequential logic with asynchronous positive edge reset and clock enable (train_valid)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken on reset
        end else if (train_valid) begin
            state <= next_state;
        end
        // else: retain current state (no update) - clock gating effect via enable
    end

endmodule