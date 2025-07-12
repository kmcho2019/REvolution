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

    // Pattern History Table (128 entries)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction path
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] updated_counter = 
        (train_taken) ? 
            ((pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1) :
            ((pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1);
    
    // GHR update logic with priority to training
    wire [6:0] next_ghr = 
        train_valid & train_mispredicted ? {train_history[5:0], train_taken} :
        predict_valid ? {ghr[5:0], predict_taken} :
        ghr;

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01)
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end
        else if (train_valid) begin
            pht[train_index] <= updated_counter;
        end
    end

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            ghr <= 7'b0;
        else
            ghr <= next_ghr;
    end

endmodule