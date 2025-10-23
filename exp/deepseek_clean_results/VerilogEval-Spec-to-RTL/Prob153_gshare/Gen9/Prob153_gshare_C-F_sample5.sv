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

    reg [6:0] ghr;
    reg [1:0] pht [0:127];

    // Only calculate indices when needed to save power
    wire [6:0] predict_index = predict_valid ? (predict_pc ^ ghr) : 7'b0;
    wire [6:0] train_index = train_valid ? (train_pc ^ train_history) : 7'b0;

    // Combinational prediction path
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Optimized reset implementation
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // PHT update with training
            if (train_valid) begin
                pht[train_index] <= train_taken ? 
                    (pht[train_index] == 2'b11 ? 2'b11 : pht[train_index] + 1) :
                    (pht[train_index] == 2'b00 ? 2'b00 : pht[train_index] - 1);
            end

            // GHR update with priority to training mispredictions
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule