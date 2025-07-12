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

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken = 1'b0;
        predict_history = 7'b0;
        history = 7'b0;
        for (i = 0; i < 128; i++) begin
            pht[i] = 2'b0;
        end
    end else begin
        reg [6:0] new_history;
        reg [1:0] new_pht;
        reg [6:0] index;

        // Calculate new history and PHT values
        if (train_valid) begin
            new_history = train_mispredicted? train_history : {history[5:0], train_taken};
            index = train_pc ^ train_history;
            if (train_taken) begin
                new_pht = (pht[index] == 2'b11)? 2'b11 : pht[index] + 1'b1;
            end else begin
                new_pht = (pht[index] == 2'b00)? 2'b00 : pht[index] - 1'b1;
            end
        end else if (predict_valid) begin
            new_history = {history[5:0], 1'b0}; // initialize with 0 for prediction
        end else begin
            new_history = history;
            new_pht = pht[0];
        end

        // Update history and PHT
        if (train_valid) begin
            history = new_history;
            pht[index] = new_pht;
        end else if (predict_valid) begin
            history = new_history;
        end

        // Generate prediction outputs
        if (predict_valid) begin
            index = predict_pc ^ history;
            if (pht[index] >= 2'b10) begin
                predict_taken = 1'b1;
            end else begin
                predict_taken = 1'b0;
            end
            predict_history = history;
        end
    end
end

endmodule