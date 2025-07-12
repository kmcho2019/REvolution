// Hybrid State Machine with Predictive Model
module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state (one-hot encoded)
reg [2:0] next_y; // next state
reg predict_valid; // predictive model validity signal
reg [2:0] predict_y; // predicted next state
reg predict_z; // predicted output

// One-hot encoding for states
always @(*) begin
    case (y)
        3'b001: next_y = x? 3'b100 : 3'b001;
        3'b010: next_y = x? 3'b001 : 3'b010;
        3'b011: next_y = x? 3'b010 : 3'b001;
        3'b100: next_y = x? 3'b100 : 3'b011;
        default: next_y = 3'b001; // Default to state 001
    endcase
end

// Predictive model for next state and output
always @(*) begin
    case (y)
        3'b001: if (x) predict_y = 3'b100; else predict_y = 3'b001;
        3'b010: if (x) predict_y = 3'b001; else predict_y = 3'b010;
        3'b011: if (x) predict_y = 3'b010; else predict_y = 3'b001;
        3'b100: if (x) predict_y = 3'b100; else predict_y = 3'b011;
        default: predict_y = 3'b001; // Default prediction
    endcase
    
    // Predict output based on predicted state
    if (predict_y == 3'b011 || predict_y == 3'b100) begin
        predict_z = 1'b1;
    end else begin
        predict_z = 1'b0;
    end
end

// Clock gating logic for state register
reg clk_enable_state;
always @(*) begin
    if (y != next_y) begin
        clk_enable_state = 1'b1;
    end else begin
        clk_enable_state = 1'b0;
    end
end

// Clock gating logic for predictive model
reg clk_enable_predict;
always @(*) begin
    if (predict_valid) begin
        clk_enable_predict = 1'b1;
    end else begin
        clk_enable_predict = 1'b0;
    end
end

// Update state and predictive model
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b001; // Reset to state 001
        predict_valid <= 1'b0;
    end else if (clk_enable_state) begin
        y <= next_y;
        predict_valid <= 1'b1;
    end
    
    if (clk_enable_predict) begin
        predict_z <= predict_z;
    end
end

// Output logic with clock gating
always @(posedge clk) begin
    if (clk_enable_predict) begin
        z <= predict_z;
    end
end

endmodule