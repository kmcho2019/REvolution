module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic for next state calculation
    always @(*) begin
        next_state = state;
        if (train_valid) begin
            case (state)
                2'b00: next_state = train_taken ? 2'b01 : 2'b00;       // increment or stay at 0
                2'b01: next_state = train_taken ? 2'b10 : 2'b00;       // up or down
                2'b10: next_state = train_taken ? 2'b11 : 2'b01;
                2'b11: next_state = train_taken ? 2'b11 : 2'b10;       // saturate at max
                default: next_state = 2'b01;                            // default fallback
            endcase
        end
    end

    // Sequential logic with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset value
        end else begin
            state <= next_state;
        end
    end

endmodule