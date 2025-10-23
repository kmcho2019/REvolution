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

wire [6:0] predict_index = predict_pc ^ history;
wire [6:0] train_index = train_pc ^ train_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid) begin
            // update pht table
            if (train_taken) begin
                if (pht[train_index] != 2'b11) begin
                    pht[train_index] <= pht[train_index] + 1;
                end
            end else begin
                if (pht[train_index] != 2'b00) begin
                    pht[train_index] <= pht[train_index] - 1;
                end
            end

            // update history
            if (train_mispredicted) begin
                history <= train_history;
            end
        end else if (predict_valid) begin
            // update history
            history <= {history[5:0], (pht[predict_index] >= 2'b10)};
        end
    end

    // generate prediction outputs
    if (predict_valid) begin
        predict_taken <= (pht[predict_index] >= 2'b10);
        predict_history <= history;
    end
end

endmodule