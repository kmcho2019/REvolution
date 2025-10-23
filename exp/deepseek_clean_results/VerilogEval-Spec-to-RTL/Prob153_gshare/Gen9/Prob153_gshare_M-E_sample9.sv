module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    reg [6:0] ghr;
    reg [1:0] pht [0:127];
    reg pending_pred_valid;
    reg pending_pred_taken;

    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // PHT update logic with arithmetic saturation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else if (train_valid) begin
            case (pht[train_index])
                2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
            endcase
        end
    end

    // Prediction pipeline - stage 1
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pending_pred_valid <= 1'b0;
        end else begin
            pending_pred_valid <= predict_valid;
            pending_pred_taken <= predict_taken;
        end
    end

    // GHR update logic with priority to training
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else if (train_valid && train_mispredicted) begin
            ghr <= {train_history[5:0], train_taken};
        end else if (train_valid) begin
            // Normal training updates GHR immediately
            ghr <= {ghr[5:0], train_taken};
        end else if (pending_pred_valid) begin
            // Delayed prediction updates
            ghr <= {ghr[5:0], pending_pred_taken};
        end
    end

endmodule