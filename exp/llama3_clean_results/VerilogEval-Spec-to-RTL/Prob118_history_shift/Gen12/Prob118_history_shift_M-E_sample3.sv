module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

// Define the FSM states
enum logic [1:0] {
    RESET,
    PREDICTION,
    MISPREDICTION,
    IDLE
} state, next_state;

// Define the clock enable signal
reg clock_enable;

always_comb begin
    // Determine the next state based on the current state and inputs
    case (state)
        RESET: next_state = (predict_valid || train_mispredicted) ? IDLE : RESET;
        PREDICTION: next_state = (train_mispredicted) ? MISPREDICTION : (predict_valid) ? PREDICTION : IDLE;
        MISPREDICTION: next_state = (predict_valid || train_mispredicted) ? IDLE : MISPREDICTION;
        IDLE: next_state = (predict_valid) ? PREDICTION : (train_mispredicted) ? MISPREDICTION : IDLE;
    endcase
    
    // Determine the clock enable signal
    clock_enable = (state == PREDICTION || state == MISPREDICTION || train_mispredicted || predict_valid);
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset
        state <= RESET;
        predict_history <= 32'd0;
    end else if (clock_enable) begin
        // Update the state
        state <= next_state;
        
        // Update the predict_history register based on the current state and inputs
        case (state)
            PREDICTION: predict_history <= {predict_history[30:0], predict_taken};
            MISPREDICTION: predict_history <= {train_history, train_taken};
            default: predict_history <= predict_history;
        endcase
    end
end

endmodule