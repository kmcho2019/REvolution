module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    localparam PHT_ENTRIES = 128;
    localparam PHT_IDX_BITS = 7;

    // 2-bit saturating counter:
    // 00 - Strongly not taken
    // 01 - Weakly not taken
    // 10 - Weakly taken
    // 11 - Strongly taken

    reg [1:0] PHT [0:PHT_ENTRIES-1];
    reg [6:0] GHR;

    // Compute prediction index (XOR of PC and GHR)
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [1:0] predict_counter = PHT[predict_index];

    assign predict_taken = predict_counter[1];  // MSB is prediction bit
    assign predict_history = GHR;

    // Compute training index (XOR of train_pc and train_history)
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // default weakly not taken
            endcase
        end
    endfunction

    integer i;

    // Next GHR calculation (priority: training misprediction recovery > prediction update > hold)
    reg [6:0] next_GHR;
    always @(*) begin
        if (train_valid && train_mispredicted)
            next_GHR = train_history;
        else if (predict_valid)
            next_GHR = {GHR[5:0], predict_taken};
        else
            next_GHR = GHR;
    end

    // Sequential logic: synchronous updates with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < PHT_ENTRIES; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
        end else begin
            // Update PHT entry on training request
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end
            // Update GHR according to priority
            GHR <= next_GHR;
        end
    end

endmodule