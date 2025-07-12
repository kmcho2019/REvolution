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

reg [6:0] global_history;
reg [1:0] gshare_table [127:0];
reg [1:0] bimodal_table [127:0];

wire [6:0] predict_index_gshare;
wire [6:0] predict_index_bimodal;
wire [6:0] train_index_gshare;
wire [6:0] train_index_bimodal;

assign predict_index_gshare = predict_pc ^ global_history;
assign predict_index_bimodal = predict_pc;
assign train_index_gshare = train_pc ^ train_history;
assign train_index_bimodal = train_pc;

reg [1:0] predict_counter_gshare;
reg [1:0] predict_counter_bimodal;
reg [6:0] new_global_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            gshare_table[i] <= 2'b00;
            bimodal_table[i] <= 2'b00;
        end
    end else begin
        if (train_valid) begin
            // Update gshare table
            if (train_taken) begin
                if (gshare_table[train_index_gshare]!= 2'b11) begin
                    gshare_table[train_index_gshare] <= gshare_table[train_index_gshare] + 1;
                end
            end else begin
                if (gshare_table[train_index_gshare]!= 2'b00) begin
                    gshare_table[train_index_gshare] <= gshare_table[train_index_gshare] - 1;
                end
            end

            // Update bimodal table
            if (train_taken) begin
                if (bimodal_table[train_index_bimodal]!= 2'b11) begin
                    bimodal_table[train_index_bimodal] <= bimodal_table[train_index_bimodal] + 1;
                end
            end else begin
                if (bimodal_table[train_index_bimodal]!= 2'b00) begin
                    bimodal_table[train_index_bimodal] <= bimodal_table[train_index_bimodal] - 1;
                end
            end

            // Update global history
            if (train_mispredicted) begin
                new_global_history <= train_history;
            end else if (train_taken) begin
                new_global_history <= {train_history[5:0], 1'b1};
            end else begin
                new_global_history <= {train_history[5:0], 1'b0};
            end
        end else if (predict_valid) begin
            // Make prediction using both tables
            predict_counter_gshare <= gshare_table[predict_index_gshare];
            predict_counter_bimodal <= bimodal_table[predict_index_bimodal];

            // Combine predictions
            if (predict_counter_gshare[1] && predict_counter_bimodal[1]) begin
                predict_taken <= 1'b1;
            end else begin
                predict_taken <= 1'b0;
            end

            predict_history <= global_history;

            // Update global history
            if (predict_taken) begin
                new_global_history <= {global_history[5:0], 1'b1};
            end else begin
                new_global_history <= {global_history[5:0], 1'b0};
            end
        end

        global_history <= new_global_history;
    end
end

endmodule