module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [1:0] pht [127:0];
reg [6:0] history;

// Combinational logic for prediction
assign predict_taken = (predict_valid) ? (pht[predict_pc ^ history] >= 2'b10) : 1'bx;
assign predict_history = (predict_valid) ? history : 7'bx;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                history <= train_history;
            end else begin
                history <= {history[5:0], train_taken};
            end
            reg [6:0] index = train_pc ^ train_history;
            if (train_taken) begin
                if (pht[index] == 2'b11) begin
                    pht[index] <= 2'b11;
                end else begin
                    pht[index] <= pht[index] + 1;
                end
            end else begin
                if (pht[index] == 2'b00) begin
                    pht[index] <= 2'b00;
                end else begin
                    pht[index] <= pht[index] - 1;
                end
            end
        end else if (predict_valid) begin
            history <= {history[5:0], 1'b1};
        end
    end
end

endmodule