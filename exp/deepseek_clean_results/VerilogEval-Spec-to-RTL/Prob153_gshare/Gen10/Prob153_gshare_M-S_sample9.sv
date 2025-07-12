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

    // Prediction logic
    wire [6:0] pred_idx = predict_pc ^ ghr;
    assign predict_taken = pht[pred_idx][1];
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_idx = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 0;
            for (integer i = 0; i < 128; i++)
                pht[i] <= 2'b01;
        end else begin
            // Training has priority
            if (train_valid) begin
                // Update PHT
                if (train_taken && pht[train_idx] != 2'b11)
                    pht[train_idx] <= pht[train_idx] + 1;
                else if (!train_taken && pht[train_idx] != 2'b00)
                    pht[train_idx] <= pht[train_idx] - 1;

                // Update GHR on misprediction
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
            end 
            // Normal prediction update
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule