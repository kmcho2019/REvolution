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

    // Pattern History Table (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? (pht[predict_index] >= 2'b10) : 1'b0;
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] updated_counter;

    // Counter update logic
    assign updated_counter = 
        (train_taken && current_counter != 2'b11) ? current_counter + 1 :
        (!train_taken && current_counter != 2'b00) ? current_counter - 1 :
        current_counter;

    // Next GHR value (considering both prediction and training)
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            // Misprediction recovery takes highest priority
            next_ghr = {train_history[5:0], train_taken};
        end else if (train_valid) begin
            // Training takes next priority
            next_ghr = {ghr[5:0], train_taken};
        end else if (predict_valid) begin
            // Prediction updates come last
            next_ghr = {ghr[5:0], predict_taken};
        end else begin
            // No change
            next_ghr = ghr;
        end
    end

    // Sequential logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all PHT entries to weakly taken (2'b10)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b10;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= updated_counter;
            end
            
            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule