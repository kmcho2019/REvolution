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
reg [1:0] pht [127:0];
reg [1:0] sub_pht [127:0][15:0];

wire [6:0] predict_index;
wire [6:0] train_index;

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

// State machine to manage the branch prediction and training
reg [1:0] state;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
            for (int j = 0; j < 16; j++) begin
                sub_pht[i][j] <= 2'b00;
            end
        end
    end else begin
        case (state)
            2'b00: begin // Prediction state
                if (predict_valid) begin
                    predict_taken <= (pht[predict_index] >= 2'b10)? 1'b1 : 1'b0;
                    predict_history <= global_history;
                    global_history <= {global_history[5:0], predict_taken};
                    state <= 2'b01;
                end
            end
            2'b01: begin // Training state
                if (train_valid) begin
                    if (train_mispredicted) begin
                        global_history <= train_history;
                    end
                    pht[train_index] <= (train_taken)? (pht[train_index] + 1'b1) : (pht[train_index] - 1'b1);
                    sub_pht[train_index][train_taken] <= (sub_pht[train_index][train_taken] + 1'b1);
                    state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule