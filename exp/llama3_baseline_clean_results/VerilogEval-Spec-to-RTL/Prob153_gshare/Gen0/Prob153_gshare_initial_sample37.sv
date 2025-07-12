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

// 128-entry table of two-bit saturating counters
reg [1:0] pht [127:0];

// 7-bit global branch history register
reg [6:0] ghr;

// Initialize pht and ghr
initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b00; // Initialize to strongly not taken
    end
    ghr = 7'b0; // Initialize to 0
end

// Hashing function to generate index
function [6:0] hash;
    input [6:0] pc;
    input [6:0] history;
    begin
        hash = pc ^ history;
    end
endfunction

// Update pht entry
always @ (posedge clk) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] = 2'b00; // Reset to strongly not taken
        end
        ghr = 7'b0; // Reset to 0
    end
    else if (train_valid) begin
        reg [6:0] index;
        index = hash(train_pc, train_history);
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht[index] = pht[index] + 1; // Increment counter
            end
        end
        else begin
            if (pht[index] != 2'b00) begin
                pht[index] = pht[index] - 1; // Decrement counter
            end
        end
        if (train_mispredicted) begin
            ghr = train_history; // Recover ghr
        end
        else if (predict_valid) begin
            ghr = {ghr[5:0], predict_taken}; // Update ghr
        end
    end
    else if (predict_valid) begin
        ghr = {ghr[5:0], predict_taken}; // Update ghr
    end
end

// Prediction logic
always @ (posedge clk) begin
    if (predict_valid) begin
        reg [6:0] index;
        index = hash(predict_pc, ghr);
        if (pht[index] >= 2'b10) begin
            predict_taken = 1'b1; // Predict taken
        end
        else begin
            predict_taken = 1'b0; // Predict not taken
        end
        predict_history = ghr; // Output current ghr
    end
end

endmodule