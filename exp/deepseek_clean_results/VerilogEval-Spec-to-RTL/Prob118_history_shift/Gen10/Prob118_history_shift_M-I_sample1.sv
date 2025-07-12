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
    reg [15:0] history_stage1; // Pipeline stage for shift operation
    wire [31:0] next_history;
    wire state_changed;

    // State change detection - only update when value actually changes
    assign state_changed = train_mispredicted || 
                          (predict_valid && (predict_taken != history_reg[0]));

    // Two-stage shift operation for better timing
    always @(*) begin
        if (train_mispredicted) begin
            history_stage1 = train_history[15:0];
            next_history = {history_stage1[14:0], train_taken, train_history[30:16]};
        end
        else if (predict_valid) begin
            history_stage1 = history_reg[15:0];
            next_history = {history_stage1[14:0], predict_taken, history_reg[30:16]};
        end
        else begin
            next_history = history_reg;
        end
    end

    // Register update with simplified enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end
        else if (state_changed) begin
            history_reg <= next_history;
        end
    end

    // Continuous output assignment
    // Note: Could be gated with valid signal if power is critical
    assign predict_history = history_reg;

endmodule