module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg current_state;
    reg predicted_state;
    reg prediction_valid;

    // State prediction and validation logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B;
            predicted_state <= STATE_B;
            prediction_valid <= 1'b1;
        end else begin
            // Validate previous prediction
            if (prediction_valid) begin
                current_state <= predicted_state;
            end else begin
                // Recovery path (not needed for this FSM but included architecturally)
                case (current_state)
                    STATE_B: current_state <= in ? STATE_B : STATE_A;
                    STATE_A: current_state <= in ? STATE_A : STATE_B;
                endcase
            end
            
            // Make new prediction
            case (current_state)
                STATE_B: predicted_state <= in ? STATE_B : STATE_A;
                STATE_A: predicted_state <= in ? STATE_A : STATE_B;
            endcase
            
            // In this simple FSM, prediction is always valid
            prediction_valid <= 1'b1;
        end
    end

    // Output based on predicted state (early output)
    assign out = (predicted_state == STATE_B);

endmodule