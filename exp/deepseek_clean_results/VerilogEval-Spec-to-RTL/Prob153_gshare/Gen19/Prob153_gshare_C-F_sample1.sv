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

    parameter PHT_SIZE = 128;
    parameter PHT_WIDTH = 2;
    parameter GHR_WIDTH = 7;

    // Global History Register
    reg [GHR_WIDTH-1:0] ghr;
    // Pattern History Table
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Prediction index and output
    wire [GHR_WIDTH-1:0] predict_idx = predict_pc ^ ghr;
    assign predict_taken = pht[predict_idx][1];
    assign predict_history = ghr;

    // Training index
    wire [GHR_WIDTH-1:0] train_idx = train_pc ^ train_history;

    // Next state calculation
    reg [GHR_WIDTH-1:0] next_ghr;
    reg [PHT_WIDTH-1:0] next_pht [0:PHT_SIZE-1];

    always @(*) begin
        // Default assignments
        next_ghr = ghr;
        for (integer i = 0; i < PHT_SIZE; i = i + 1)
            next_pht[i] = pht[i];

        // GHR update priority: training mispredictions first
        if (train_valid && train_mispredicted) begin
            next_ghr = {train_history[GHR_WIDTH-2:0], train_taken};
        end
        else if (predict_valid) begin
            next_ghr = {ghr[GHR_WIDTH-2:0], predict_taken};
        end

        // PHT update
        if (train_valid) begin
            case (pht[train_idx])
                2'b00: next_pht[train_idx] = train_taken ? 2'b01 : 2'b00;
                2'b01: next_pht[train_idx] = train_taken ? 2'b10 : 2'b00;
                2'b10: next_pht[train_idx] = train_taken ? 2'b11 : 2'b01;
                2'b11: next_pht[train_idx] = train_taken ? 2'b11 : 2'b10;
            endcase
        end
    end

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT
            ghr <= {GHR_WIDTH{1'b0}};
            for (integer j = 0; j < PHT_SIZE; j = j + 1)
                pht[j] <= 2'b01;  // Weakly not-taken
        end
        else begin
            // Update GHR and PHT
            ghr <= next_ghr;
            for (integer j = 0; j < PHT_SIZE; j = j + 1)
                pht[j] <= next_pht[j];
        end
    end

endmodule