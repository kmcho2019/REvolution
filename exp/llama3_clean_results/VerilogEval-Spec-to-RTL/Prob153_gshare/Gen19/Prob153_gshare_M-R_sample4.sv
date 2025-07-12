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

reg [1:0] gshare_pht [127:0]; // Corrected size for 7-bit index
reg [6:0] history;

// Calculate index for gshare_pht
wire [6:0] gshare_index = predict_pc ^ history;

// Training logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gshare_pht <= '{default: 2'b0}; // Initialize all entries to 0
        history <= 7'b0;
    end else if (train_valid) begin
        if (train_mispredicted) begin
            history <= train_history; // Recover history on mispredict
        end
        
        // Update gshare_pht based on training inputs
        if (train_taken) begin
            if (gshare_pht[{train_pc[6:0]}] != 2'b11) begin
                gshare_pht[{train_pc[6:0]}] <= gshare_pht[{train_pc[6:0]}] + 1;
            end
        end else begin
            if (gshare_pht[{train_pc[6:0]}] != 2'b00) begin
                gshare_pht[{train_pc[6:0]}] <= gshare_pht[{train_pc[6:0]}] - 1;
            end
        end
    end
end

// Prediction logic
always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= (gshare_pht[gshare_index] >= 2'b10); // Predict taken if counter is 2 or 3
        predict_history <= history;
        
        // Update history register based on prediction
        if (!train_valid || !train_mispredicted) begin
            history <= {history[5:0], predict_taken};
        end
    end
end

endmodule