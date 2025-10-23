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

reg [6:0] global_history;
reg [6:0] recover_history;
reg [1:0] pht [127:0];
reg stable [127:0];
reg [3:0] counter [127:0];

wire [6:0] predict_index;
wire [6:0] train_index;

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        recover_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
            stable[i] <= 1'b0;
            counter[i] <= 4'b0000;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                recover_history <= train_history;
            end else if (!predict_valid || train_index != predict_index) begin
                if (train_taken) begin
                    recover_history <= {global_history[5:0], 1'b1};
                end else begin
                    recover_history <= {global_history[5:0], 1'b0};
                end
            end

            if (train_taken) begin
                if (pht[train_index] == 2'b00) begin
                    pht[train_index] <= 2'b01;
                end else if (pht[train_index] == 2'b01) begin
                    pht[train_index] <= 2'b11;
                end

                if (counter[train_index] == 4'b0000) begin
                    counter[train_index] <= 4'b0001;
                end else if (counter[train_index] == 4'b1111) begin
                    counter[train_index] <= 4'b1111;
                end else begin
                    counter[train_index] <= counter[train_index] + 1'b1;
                end

                if (counter[train_index] == 4'b1000) begin
                    stable[train_index] <= 1'b1;
                end
            end else begin
                if (pht[train_index] == 2'b11) begin
                    pht[train_index] <= 2'b10;
                end else if (pht[train_index] == 2'b10) begin
                    pht[train_index] <= 2'b00;
                end

                if (counter[train_index] == 4'b0000) begin
                    counter[train_index] <= 4'b0000;
                end else if (counter[train_index] == 4'b1111) begin
                    counter[train_index] <= 4'b1111;
                end else begin
                    counter[train_index] <= counter[train_index] - 1'b1;
                end

                if (counter[train_index] == 4'b0000) begin
                    stable[train_index] <= 1'b0;
                end
            end
        end else if (predict_valid) begin
            if (stable[predict_index]) begin
                predict_taken <= (pht[predict_index] == 2'b11 || pht[predict_index] == 2'b10);
            end else begin
                predict_taken <= 1'b1;
            end

            predict_history <= global_history;
        end

        global_history <= recover_history;
    end
end

endmodule