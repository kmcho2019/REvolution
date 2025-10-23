module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam [4:0] 
        IDLE  = 5'b00001,
        S1    = 5'b00010,
        S2    = 5'b00100,
        S3    = 5'b01000,
        FOUND = 5'b10000;

    reg [4:0] current_state, next_state;
    wire clk_gated;

    // Clock gating when in FOUND state
    assign clk_gated = (current_state == FOUND) ? 1'b0 : clk;

    // State transition logic
    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            start_shifting <= (next_state == FOUND);
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = data ? S1 : IDLE;
            S1:    next_state = data ? S2 : IDLE;
            S2:    next_state = data ? S2 : S3;
            S3:    next_state = data ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

endmodule