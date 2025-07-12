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

    // Asynchronous reset handling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end
    end

    // Main update logic
    always @(posedge clk) begin
        if (~areset) begin
            if (train_mispredicted) begin
                // Rollback case: use train_history + actual taken
                history_reg <= {train_history[30:0], train_taken};
            end
            else if (predict_valid) begin
                // Normal prediction case: shift in new prediction
                history_reg <= {history_reg[30:0], predict_taken};
            end
            // Else maintain current value (implicit)
        end
    end

    // Output assignment
    assign predict_history = history_reg;

endmodule