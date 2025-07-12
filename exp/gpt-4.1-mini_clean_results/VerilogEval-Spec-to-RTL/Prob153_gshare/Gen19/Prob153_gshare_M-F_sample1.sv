module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // 2-bit saturating counters:
    // 00 = strongly not taken
    // 01 = weakly not taken
    // 10 = weakly taken
    // 11 = strongly taken
    reg [1:0] pht [0:127];

    // Separate global history registers:
    // fetch_ghr: for predictions, updated by prediction results each cycle
    // train_ghr: for training updates and recovery after misprediction
    reg [6:0] fetch_ghr;
    reg [6:0] train_ghr;

    // Latches to hold prediction outputs
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Prediction index and counter read (combinational)
    wire [6:0] predict_index = predict_pc ^ fetch_ghr;
    wire [1:0] predict_counter = pht[predict_index];

    // Prediction taken: MSB of saturating counter
    wire predict_taken_wire = predict_counter[1];

    // Training index computed combinationally outside always block
    wire [6:0] train_index = train_pc ^ train_history;

    // Outputs assigned from registers
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    // Saturating counter update function (pure combinational)
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            fetch_ghr <= 7'b0;
            train_ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Prediction outputs latched from combinational values at this cycle
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_wire;
                predict_history_reg <= fetch_ghr;
            end
            // else keep old outputs

            // Training updates to PHT and train_ghr
            if (train_valid) begin
                // Update saturating counter at training index with actual branch outcome
                pht[train_index] <= saturate_update(pht[train_index], train_taken);

                // Update train_ghr depending on misprediction
                if (train_mispredicted) begin
                    // Recover train_ghr to train_history (flush)
                    train_ghr <= train_history;
                end else begin
                    // Shift in actual taken bit
                    train_ghr <= {train_ghr[5:0], train_taken};
                end
            end

            // Recover fetch_ghr from flush history or update with prediction
            if (train_valid && train_mispredicted) begin
                // Use train_history directly to avoid stale train_ghr at flush
                fetch_ghr <= train_history;
            end else if (predict_valid) begin
                fetch_ghr <= {fetch_ghr[5:0], predict_taken_wire};
            end
            // else fetch_ghr holds steady if no prediction or flush
        end
    end

endmodule