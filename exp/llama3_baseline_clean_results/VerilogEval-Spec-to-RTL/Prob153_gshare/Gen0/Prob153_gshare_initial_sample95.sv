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

    reg [6:0] global_history;
    reg [6:0] global_history_next;
    reg [6:0] pht_index;
    reg [1:0] pht_entry [0:127];
    wire [1:0] pht_out;
    reg [1:0] pht_out_reg;

    // Asynchronous active-high reset
    always @(posedge areset or negedge clk) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht_entry[i] <= 2'b0;
            end
        end else if (clk) begin
            global_history <= global_history_next;
            pht_out_reg <= pht_out;
        end
    end

    // Update global history
    always @(*) begin
        if (predict_valid) begin
            global_history_next = {global_history[5:0], predict_taken};
        end else if (train_valid && train_mispredicted) begin
            global_history_next = train_history;
        end else begin
            global_history_next = global_history;
        end
    end

    // Generate PHT index
    assign pht_index = predict_pc ^ global_history;

    // Read PHT entry
    assign pht_out = pht_entry[pht_index];

    // Prediction logic
    always @(*) begin
        if (predict_valid) begin
            if (pht_out_reg[1]) begin
                predict_taken = 1'b1;
            end else begin
                predict_taken = 1'b0;
            end
            predict_history = global_history;
        end
    end

    // Training logic
    always @(posedge clk) begin
        if (train_valid) begin
            if (train_taken) begin
                if (pht_entry[train_pc ^ train_history] < 2'b11) begin
                    pht_entry[train_pc ^ train_history] <= pht_entry[train_pc ^ train_history] + 1'b1;
                end
            end else begin
                if (pht_entry[train_pc ^ train_history] > 2'b00) begin
                    pht_entry[train_pc ^ train_history] <= pht_entry[train_pc ^ train_history] - 1'b1;
                end
            end
        end
    end

endmodule