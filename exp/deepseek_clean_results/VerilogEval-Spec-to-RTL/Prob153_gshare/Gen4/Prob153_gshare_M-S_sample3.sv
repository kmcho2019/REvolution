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

    // Combinational prediction outputs
    assign predict_taken = predict_valid ? pht[predict_pc ^ ghr][1] : 1'b0;
    assign predict_history = ghr;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            if (train_valid) begin
                // Update PHT
                pht[train_pc ^ train_history] <= 
                    train_taken ? 
                        (pht[train_pc ^ train_history] == 2'b11 ? 2'b11 : pht[train_pc ^ train_history] + 1) :
                        (pht[train_pc ^ train_history] == 2'b00 ? 2'b00 : pht[train_pc ^ train_history] - 1);
                
                // Update GHR
                ghr <= train_mispredicted ? {train_history[5:0], train_taken} : {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Only update GHR if no training
                ghr <= {ghr[5:0], pht[predict_pc ^ ghr][1]};
            end
        end
    end

endmodule