module TopModule(
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

// GBHR register
reg [6:0] gbhr;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'b0;
    end else if (predict_valid) begin
        gbhr <= {gbhr[5:0], predict_taken};
    end else if (train_valid && train_mispredicted) begin
        gbhr <= train_history;
    end
end

// gshare predictor
reg [1:0] gshare_pht [127:0];
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            gshare_pht[i] <= 2'b01; // initialize to weakly taken
        end
    end else if (train_valid) begin
        reg [1:0] new_val;
        reg [6:0] index;
        index = {train_pc[6:1], gbhr[0]};
        new_val = gshare_pht[index];
        if (train_taken) begin
            if (new_val != 2'b11) begin
                new_val = new_val + 1'b1;
            end
        end else begin
            if (new_val != 2'b00) begin
                new_val = new_val - 1'b1;
            end
        end
        gshare_pht[index] <= new_val;
    end
end

// perceptron predictor
reg [6:0] perceptron_weights [6:0];
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 7; i++) begin
            perceptron_weights[i] <= 7'b0;
        end
    end else if (train_valid) begin
        reg [6:0] prediction;
        reg [6:0] error;
        prediction = 7'b0;
        for (int i = 0; i < 7; i++) begin
            prediction = prediction + (gbhr[i] ? perceptron_weights[i] : 7'b0);
        end
        error = (train_taken ? 7'b1 : 7'b0) - (prediction[6] ? 7'b1 : 7'b0);
        for (int i = 0; i < 7; i++) begin
            perceptron_weights[i] <= perceptron_weights[i] + (gbhr[i] ? error : 7'b0);
        end
    end
end

// hybrid predictor
reg predict_taken_reg;
always @(posedge clk) begin
    if (predict_valid) begin
        reg [6:0] index;
        reg [6:0] prediction;
        index = {predict_pc[6:1], gbhr[0]};
        prediction = 7'b0;
        for (int i = 0; i < 7; i++) begin
            prediction = prediction + (gbhr[i] ? perceptron_weights[i] : 7'b0);
        end
        if (gshare_pht[index] == 2'b11 || gshare_pht[index] == 2'b00) begin
            predict_taken_reg <= gshare_pht[index][1];
        end else begin
            predict_taken_reg <= prediction[6];
        end
        predict_history <= gbhr;
    end
end

assign predict_taken = predict_taken_reg;

endmodule