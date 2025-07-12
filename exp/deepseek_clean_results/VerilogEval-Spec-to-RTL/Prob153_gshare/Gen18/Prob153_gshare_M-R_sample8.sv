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

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Initialize PHT (for simulation)
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            pht[i] = 2'b01;  // Weakly not-taken
        end
    end

    // Prediction is combinational
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next GHR value with priority handling
    wire [6:0] next_ghr = 
        (train_valid && train_mispredicted) ? {train_history[5:0], train_taken} :
        (predict_valid) ? {ghr[5:0], predict_taken} :
        ghr;

    // PHT update logic
    wire [1:0] current_pht_state = pht[train_index];
    wire [1:0] updated_pht_state = 
        train_taken ? 
            (current_pht_state == 2'b11) ? 2'b11 : (current_pht_state + 1) :
            (current_pht_state == 2'b00) ? 2'b00 : (current_pht_state - 1);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= updated_pht_state;
            end
        end
    end

endmodule