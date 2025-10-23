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

    reg [31:0] main_history;
    reg [31:0] speculative_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            main_history <= 32'b0;
            speculative_history <= 32'b0;
        end else begin
            // Main history update (training path)
            if (train_mispredicted) begin
                main_history <= {train_history[30:0], train_taken};
                speculative_history <= {train_history[30:0], train_taken};
            end
            
            // Speculative history update (prediction path)
            if (predict_valid && !train_mispredicted) begin
                speculative_history <= {speculative_history[30:0], predict_taken};
            end
            
            // Commit valid predictions to main history
            if (!train_mispredicted && !predict_valid) begin
                main_history <= speculative_history;
            end
        end
    end

    // Output is always the speculative history for predictions
    assign predict_history = (predict_valid || !train_mispredicted) ? 
                           speculative_history : {train_history[30:0], train_taken};

endmodule