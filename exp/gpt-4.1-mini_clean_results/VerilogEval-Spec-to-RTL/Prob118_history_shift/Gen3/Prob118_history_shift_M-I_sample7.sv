module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input        predict_taken,
    input        train_mispredicted,
    input        train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

    reg [31:0] next_history;
    wire       update_en;

    assign update_en = train_mispredicted | predict_valid;

    always @(*) begin
        if (train_mispredicted) begin
            // On misprediction, load corrected history with train_taken as LSB
            next_history = {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift left by 1 and shift in predict_taken at LSB
            next_history = {predict_history[30:0], predict_taken};
        end else begin
            // Hold current history
            next_history = predict_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_en) begin
            predict_history <= next_history;
        end
    end

endmodule