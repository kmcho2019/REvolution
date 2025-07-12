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

    reg [31:0] current_history;
    reg [31:0] next_history;
    
    // Parallel computation of all possible next states
    wire [31:0] reset_history = 32'b0;
    wire [31:0] mispred_history = {train_history[30:0], train_taken};
    wire [31:0] predict_history_update = {current_history[30:0], predict_taken};
    
    // Priority selection logic
    always @(*) begin
        if (areset) begin
            next_history = reset_history;
        end else if (train_mispredicted) begin
            next_history = mispred_history;
        end else if (predict_valid) begin
            next_history = predict_history_update;
        end else begin
            next_history = current_history;
        end
    end
    
    // Sequential update
    always @(posedge clk) begin
        current_history <= next_history;
    end
    
    assign predict_history = current_history;

endmodule