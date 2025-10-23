module TopModule (
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

// Pattern History Table (PHT)
reg [1:0] pht [0:127];

// Global Branch History Register
reg [6:0] ghistory;

// Combinatorial logic for prediction
wire [6:0] predict_index;
assign predict_index = predict_pc ^ ghistory;

always_comb begin
    predict_taken = (pht[predict_index] == 2'b11) || (pht[predict_index] == 2'b10);
    predict_history = ghistory;
end

// Combinatorial logic for training
wire [6:0] train_index;
assign train_index = train_pc ^ train_history;

always_comb begin
    // Update PHT
    if (train_valid && train_taken) begin
        if (pht[train_index] != 2'b11) begin
            pht[train_index] = pht[train_index] + 1;
        end
    end else if (train_valid && !train_taken) begin
        if (pht[train_index] != 2'b00) begin
            pht[train_index] = pht[train_index] - 1;
        end
    end
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghistory <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            ghistory <= train_history;
        end else if (predict_valid) begin
            ghistory <= {ghistory[5:0], predict_taken};
        end
        if (train_valid) begin
            if (train_taken) begin
                if (pht[train_index] != 2'b11) begin
                    pht[train_index] <= pht[train_index] + 1;
                end
            end else begin
                if (pht[train_index] != 2'b00) begin
                    pht[train_index] <= pht[train_index] - 1;
                end
            end
        end
    end
end

endmodule