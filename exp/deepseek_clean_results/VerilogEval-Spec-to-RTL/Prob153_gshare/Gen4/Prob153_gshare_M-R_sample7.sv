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

    // Pattern History Table
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;

    // Initialize PHT to weakly taken (2'b10)
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            pht[i] = 2'b10;
        end
    end

    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] next_pht_state;
    
    // Next counter state calculation
    assign next_pht_state = 
        (pht[train_index] == 2'b00) ? (train_taken ? 2'b01 : 2'b00) :
        (pht[train_index] == 2'b01) ? (train_taken ? 2'b10 : 2'b00) :
        (pht[train_index] == 2'b10) ? (train_taken ? 2'b11 : 2'b01) :
                                      (train_taken ? 2'b11 : 2'b10);

    // GHR next state calculation
    wire [6:0] next_ghr_train = train_mispredicted ? {train_history[5:0], train_taken} : {ghr[5:0], train_taken};
    wire [6:0] next_ghr_predict = {ghr[5:0], predict_taken};
    wire [6:0] next_ghr = train_valid ? next_ghr_train : (predict_valid ? next_ghr_predict : ghr);

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            // PHT already initialized
        end else begin
            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= next_pht_state;
            end
            
            // Update GHR based on priority
            ghr <= next_ghr;
        end
    end

endmodule