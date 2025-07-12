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

    reg [31:0] history_reg;
    wire [31:0] next_history;

    // Misprediction has priority - restore history + actual taken
    wire [31:0] mispred_history = {train_history[30:0], train_taken};
    
    // Normal prediction - shift in new prediction
    wire [31:0] pred_history = {history_reg[30:0], predict_taken};
    
    // Next state selection
    assign next_history = train_mispredicted ? mispred_history :
                         predict_valid ? pred_history :
                         history_reg;

    // Register update with async reset
    assign predict_history = history_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            history_reg <= 32'b0;
        else
            history_reg <= next_history;
    end

endmodule