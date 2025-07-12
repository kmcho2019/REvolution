module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    // Two separate history registers
    reg [31:0] prediction_history;
    reg [31:0] training_history;
    
    // Output selection mux
    assign predict_history = train_mispredicted ? training_history : prediction_history;
    
    // Prediction path (frequent updates)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            prediction_history <= 32'b0;
        end else if (predict_valid && !train_mispredicted) begin
            prediction_history <= {prediction_history[30:0], predict_taken};
        end
    end
    
    // Training path (infrequent updates)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            training_history <= 32'b0;
        end else if (train_mispredicted) begin
            training_history <= {train_history[30:0], train_taken};
            // Also update prediction history to match
            prediction_history <= {train_history[30:0], train_taken};
        end
    end

endmodule