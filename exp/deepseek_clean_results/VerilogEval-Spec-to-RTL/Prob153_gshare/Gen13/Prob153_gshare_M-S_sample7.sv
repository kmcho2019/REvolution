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

    // Combinational prediction
    assign predict_taken = pht[predict_pc ^ ghr][1];
    assign predict_history = ghr;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT and GHR
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // PHT updates
            if (train_valid) begin
                if (train_taken)
                    pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b11) ? 2'b11 : pht[train_pc ^ train_history] + 1;
                else
                    pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b00) ? 2'b00 : pht[train_pc ^ train_history] - 1;
            end

            // GHR updates (training has priority)
            if (train_valid && train_mispredicted)
                ghr <= {train_history[5:0], train_taken};
            else if (predict_valid)
                ghr <= {ghr[5:0], predict_taken};
        end
    end

endmodule