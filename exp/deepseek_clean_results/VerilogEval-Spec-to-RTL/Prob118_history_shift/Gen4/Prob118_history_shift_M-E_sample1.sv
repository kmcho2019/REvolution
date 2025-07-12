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

    // Committed history (post-training)
    reg [31:0] main_history;
    // Speculative history (predictions)
    reg [31:0] spec_history;
    
    // Next state signals
    wire [31:0] next_main_history;
    wire [31:0] next_spec_history;
    
    // Main history update (training has priority)
    assign next_main_history = train_mispredicted ? {train_history[30:0], train_taken} :
                              ~train_mispredicted ? spec_history :
                              main_history;
    
    // Speculative history update (only when predicting)
    assign next_spec_history = predict_valid ? {main_history[30:0], predict_taken} :
                               main_history;
    
    // Update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            main_history <= 32'b0;
            spec_history <= 32'b0;
        end else begin
            // Main history always updates based on training or commits spec
            main_history <= next_main_history;
            
            // Speculative history only updates when needed
            if (predict_valid || train_mispredicted) begin
                spec_history <= next_spec_history;
            end
        end
    end
    
    // Output is always the speculative state (for prediction)
    assign predict_history = spec_history;

endmodule