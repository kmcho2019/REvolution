module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam S0 = 3'b000;  // Initial state
    localparam S1 = 3'b001;  // Received '1'
    localparam S2 = 3'b010;  // Received '11'
    localparam S3 = 3'b100;  // Received '110'

    reg [2:0] state, next_state;
    wire fsm_enable = !start_shifting;  // Only update FSM until pattern found

    // State transition logic
    always @(*) begin
        if (!fsm_enable) begin
            next_state = state;  // Freeze state after detection
        end else begin
            case (state)
                S0: next_state = data ? S1 : S0;
                S1: next_state = data ? S2 : S0;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S0 : S0;  // S3->S0 if 0, pattern complete if 1
                default: next_state = S0;
            endcase
        end
    end

    // Output and state update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Set output when we get '1101' (in S3 and data=1)
            if (fsm_enable && (state == S3) && data) begin
                start_shifting <= 1'b1;
            end
        end
    end

endmodule