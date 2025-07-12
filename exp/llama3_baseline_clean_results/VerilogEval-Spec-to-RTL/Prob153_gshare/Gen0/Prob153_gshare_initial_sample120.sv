module TopModule(
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

reg [6:0] gshare_history;
reg [1:0] pattern_history_table [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gshare_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pattern_history_table[i] <= 2'b01;
        end
    end else begin
        if (train_valid) begin
            reg [6:0] index;
            index = train_pc ^ train_history;
            if (train_mispredicted) begin
                if (train_taken) begin
                    if (pattern_history_table[index] != 2'b11) begin
                        pattern_history_table[index] <= pattern_history_table[index] + 1;
                    end
                end else begin
                    if (pattern_history_table[index] != 2'b00) begin
                        pattern_history_table[index] <= pattern_history_table[index] - 1;
                    end
                end
                gshare_history <= train_history;
            end else begin
                if (train_taken) begin
                    if (pattern_history_table[index] != 2'b11) begin
                        pattern_history_table[index] <= pattern_history_table[index] + 1;
                    end
                end else begin
                    if (pattern_history_table[index] != 2'b00) begin
                        pattern_history_table[index] <= pattern_history_table[index] - 1;
                    end
                end
            end
        end
        if (predict_valid && !train_valid || predict_valid && train_valid && !train_mispredicted) begin
            gshare_history <= {gshare_history[5:0], predict_taken};
        end
    end
end

always @(*) begin
    reg [6:0] index;
    index = predict_pc ^ gshare_history;
    if (pattern_history_table[index] >= 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    predict_history = gshare_history;
end

endmodule