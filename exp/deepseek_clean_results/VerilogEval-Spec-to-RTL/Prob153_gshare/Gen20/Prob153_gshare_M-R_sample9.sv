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

    parameter PHT_SIZE = 128;
    parameter PHT_WIDTH = 2;

    // 7-bit global history register
    reg [6:0] ghr;
    // Pattern history table (2-bit saturating counters)
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Combinational prediction path
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Next GHR value calculation with priority using continuous assignments
    wire [6:0] next_ghr = train_valid && train_mispredicted ? {train_history[5:0], train_taken} :
                          predict_valid ? {ghr[5:0], predict_taken} :
                          ghr;

    // PHT update logic
    reg [PHT_WIDTH-1:0] next_pht_state;
    always @(*) begin
        if (train_valid) begin
            case (pht[train_index])
                2'b00: next_pht_state = train_taken ? 2'b01 : 2'b00;
                2'b01: next_pht_state = train_taken ? 2'b10 : 2'b00;
                2'b10: next_pht_state = train_taken ? 2'b11 : 2'b01;
                2'b11: next_pht_state = train_taken ? 2'b11 : 2'b10;
                default: next_pht_state = pht[train_index];
            endcase
        end else begin
            next_pht_state = pht[train_index];  // No change if not training
        end
    end

    // Sequential updates
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;

            // Update PHT if training
            if (train_valid) begin
                pht[train_index] <= next_pht_state;
            end
        end
    end

endmodule