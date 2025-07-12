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

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            // Output is gated - only changes when not in FOUND state
            if (current_state != FOUND) begin
                start_shifting <= (next_state == FOUND);
            end
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