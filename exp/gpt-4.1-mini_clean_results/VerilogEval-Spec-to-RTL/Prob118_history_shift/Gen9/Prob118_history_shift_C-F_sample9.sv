module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0] predict_history
);

    wire update_enable = train_mispredicted | predict_valid;
    reg [31:0] next_history;

    always @(*) begin
        if (train_mispredicted) begin
            // On misprediction, roll back with train_history[30:0] plus train_taken LSB
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in predict_taken at LSB
            next_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current state if no update
            next_history = predict_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_history;
        // else hold current predict_history value (no clock enable needed; inferred by condition)
    end

endmodule