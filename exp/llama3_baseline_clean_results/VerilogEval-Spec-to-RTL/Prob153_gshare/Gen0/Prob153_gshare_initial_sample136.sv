module TopModule(
    input  logic        clk,
    input  logic        areset,

    input  logic        predict_valid,
    input  logic [6:0]  predict_pc,
    output logic        predict_taken,
    output logic [6:0]  predict_history,

    input  logic        train_valid,
    input  logic        train_taken,
    input  logic        train_mispredicted,
    input  logic [6:0]  train_history,
    input  logic [6:0]  train_pc
);

    logic [6:0]  global_history;
    logic [6:0]  predict_index;
    logic [6:0]  train_index;
    logic [1:0]  pht [127:0];

    // Initialize PHT with weakly not taken (2'b01)
    initial begin
        for (int i = 0; i < 128; i++) begin
            pht[i] = 2'b01;
        end
    end

    // Update PHT and global history on positive clock edge
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            if (train_valid) begin
                pht[train_index] <= (train_taken && train_mispredicted) ? (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1'b1 :
                                             (train_taken && ~train_mispredicted) ? pht[train_index] : (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1'b1;
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end
            if (predict_valid && ~train_mispredicted) begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

    // Generate index for PHT
    always_comb begin
        predict_index = predict_pc[6:0] ^ global_history;
        train_index = train_pc[6:0] ^ train_history;
    end

    // Make prediction
    always_comb begin
        if (predict_valid) begin
            predict_taken = (pht[predict_index] >= 2'b10);
            predict_history = global_history;
        end
    end

endmodule