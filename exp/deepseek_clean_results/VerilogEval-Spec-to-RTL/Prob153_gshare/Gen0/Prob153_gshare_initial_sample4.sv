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

    // 7-bit global history register
    reg [6:0] ghr;

    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] new_counter;

    // Counter update logic
    always @(*) begin
        if (train_taken) begin
            case (current_counter)
                2'b00: new_counter = 2'b01;
                2'b01: new_counter = 2'b10;
                2'b10, 2'b11: new_counter = 2'b11;
            endcase
        end else begin
            case (current_counter)
                2'b00, 2'b01: new_counter = 2'b00;
                2'b10: new_counter = 2'b01;
                2'b11: new_counter = 2'b10;
            endcase
        end
    end

    // Next GHR value logic
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            // On misprediction, recover to train_history << 1 | train_taken
            next_ghr = {train_history[5:0], train_taken};
        end else if (train_valid) begin
            // Normal training updates GHR with actual outcome
            next_ghr = {ghr[5:0], train_taken};
        end else if (predict_valid) begin
            // Prediction updates GHR with predicted outcome
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
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly taken initial state
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;

            // Update PHT on training
            if (train_valid) begin
                pht[train_index] <= new_counter;
            end
        end
    end

endmodule