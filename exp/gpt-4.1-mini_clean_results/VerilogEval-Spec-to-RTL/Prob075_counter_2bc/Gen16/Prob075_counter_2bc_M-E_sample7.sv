module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic for next state
    always @(*) begin
        if (!train_valid) begin
            next_state = state; // no change when not training
        end else begin
            case (state)
                2'b00: next_state = train_taken ? 2'b01 : 2'b00; // saturate at 0
                2'b01: next_state = train_taken ? 2'b10 : 2'b00;
                2'b10: next_state = train_taken ? 2'b11 : 2'b01;
                2'b11: next_state = train_taken ? 2'b11 : 2'b10; // saturate at 3
                default: next_state = 2'b01;
            endcase
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule