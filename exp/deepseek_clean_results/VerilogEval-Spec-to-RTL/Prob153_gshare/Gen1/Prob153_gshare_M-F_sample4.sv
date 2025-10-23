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

    // 128-entry PHT of 2-bit saturating counters
    reg [1:0] pht [0:127];
    reg [6:0] ghr;

    // Prediction logic (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;  // Current GHR state

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] updated_counter;

    // 2-bit saturating counter update logic
    assign updated_counter = train_taken ? 
                            (current_counter == 2'b11 ? 2'b11 : current_counter + 1) :
                            (current_counter == 2'b00 ? 2'b00 : current_counter - 1);

    // GHR update logic with clear priority
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            // Misprediction recovery takes highest priority
            next_ghr = {train_history[5:0], train_taken};
        end
        else if (train_valid) begin
            // Normal training updates GHR with actual outcome
            next_ghr = {ghr[5:0], train_taken};
        end
        else if (predict_valid) begin
            // Prediction updates GHR with predicted outcome
            next_ghr = {ghr[5:0], predict_taken};
        end
        else begin
            // No change
            next_ghr = ghr;
        end
    end

    // Sequential logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not taken (better initial state)
            end
        end else begin
            // Update PHT if training (next cycle effect)
            if (train_valid) begin
                pht[train_index] <= updated_counter;
            end

            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule