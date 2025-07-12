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

    // Global history register
    reg [GHR_WIDTH-1:0] ghr;
    // Pattern history table
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Combinational prediction
    wire [GHR_WIDTH-1:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [GHR_WIDTH-1:0] train_index = train_pc ^ train_history;

    // Next GHR value (training has priority)
    wire [GHR_WIDTH-1:0] next_ghr = train_valid && train_mispredicted ? {train_history[GHR_WIDTH-2:0], train_taken} :
                                    predict_valid ? {ghr[GHR_WIDTH-2:0], predict_taken} :
                                    ghr;

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= {GHR_WIDTH{1'b0}};
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;

            // Update PHT if training
            if (train_valid) begin
                if (train_taken) begin
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                end else begin
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
                end
            end
        end
    end

endmodule