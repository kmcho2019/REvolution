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

    // Combinational prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    
    // Next counter value calculation
    wire [1:0] updated_counter;
    assign updated_counter = train_taken ?
        (current_counter == 2'b11 ? 2'b11 : current_counter + 1) :
        (current_counter == 2'b00 ? 2'b00 : current_counter - 1);

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else if (train_valid && train_mispredicted) begin
            // Training takes priority for mispredictions
            ghr <= {train_history[5:0], train_taken};
        end else if (train_valid) begin
            // Normal training update
            ghr <= {ghr[5:0], train_taken};
        end else if (predict_valid) begin
            // Prediction update
            ghr <= {ghr[5:0], predict_taken};
        end
    end

    // PHT initialization and updates
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to weakly taken (2'b10)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b10;
        end else if (train_valid) begin
            // Update PHT entry for training
            pht[train_index] <= updated_counter;
        end
    end

endmodule