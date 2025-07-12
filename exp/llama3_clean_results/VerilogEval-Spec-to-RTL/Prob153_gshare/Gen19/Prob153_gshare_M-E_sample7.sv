module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [1:0] pht [127:0];
reg [6:0] history;
reg [6:0] predicted_history;
reg [1:0] buffered_pht;
reg [6:0] buffered_index;

always @(posedge clk) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        predicted_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (predict_valid) begin
            reg [6:0] index = predict_pc ^ history;
            buffered_index <= index;
            buffered_pht <= pht[index];
            predict_taken <= (buffered_pht >= 2'b10);
            predict_history <= history;
            predicted_history <= {history[5:0], predict_taken};
        end
    end
end

always @(negedge clk) begin
    if (areset) begin
        history <= 7'b0;
    end else begin
        if (train_valid) begin
            reg [6:0] index = train_pc ^ train_history;
            if (train_taken) begin
                if (pht[index] != 2'b11) begin
                    pht[index] <= pht[index] + 1;
                end
            end else begin
                if (pht[index] != 2'b00) begin
                    pht[index] <= pht[index] - 1;
                end
            end
            if (train_mispredicted) begin
                history <= train_history;
            end
        end else if (predict_valid) begin
            history <= predicted_history;
        end
    end
end

endmodule