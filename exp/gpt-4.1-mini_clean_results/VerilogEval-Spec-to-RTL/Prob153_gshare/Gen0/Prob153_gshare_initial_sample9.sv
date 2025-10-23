module TopModule(
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

    // Pattern History Table: 128 entries, 2-bit saturating counters
    // States: 0-3, >=2 means predict taken
    reg [1:0] pht [0:127];
    integer i;

    // Global history register
    reg [6:0] global_history;

    // Internal wires for index calculation
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read current PHT counters (combinational)
    wire [1:0] predict_pht_counter = pht[predict_index];

    // Prediction output: taken if counter >= 2
    assign predict_taken = (predict_pht_counter >= 2) && predict_valid;

    // Output the history used for prediction (history before update)
    assign predict_history = (predict_valid) ? global_history : 7'b0;

    // Next global history values
    wire predicted_bit = (predict_pht_counter >= 2) ? 1'b1 : 1'b0;
    wire [6:0] pred_gh_next = {global_history[5:0], predicted_bit};

    // For PHT update on training:
    // Update saturating counter based on train_taken

    // Current value of PHT for train_index
    reg [1:0] train_pht_counter_current;

    // Next PHT state after training update
    reg [1:0] train_pht_counter_next;

    // Functions for saturating counter increment/decrement
    function [1:0] sat_inc(input [1:0] val);
        begin
            if (val == 2'b11)
                sat_inc = 2'b11;
            else
                sat_inc = val + 1;
        end
    endfunction

    function [1:0] sat_dec(input [1:0] val);
        begin
            if (val == 2'b00)
                sat_dec = 2'b00;
            else
                sat_dec = val - 1;
        end
    endfunction

    // On clock edge, update registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            global_history <= 7'b0;
        end else begin
            // Update PHT entry on training
            if (train_valid) begin
                train_pht_counter_current = pht[train_index];
                if (train_taken)
                    train_pht_counter_next = sat_inc(train_pht_counter_current);
                else
                    train_pht_counter_next = sat_dec(train_pht_counter_current);
                pht[train_index] <= train_pht_counter_next;
            end

            // Update global history register with priority to training if mispredicted
            if (train_valid && train_mispredicted) begin
                // Recover global history to state after mispredicting branch completes
                global_history <= train_history;
            end else if (predict_valid) begin
                global_history <= pred_gh_next;
            end
            // else keep global_history unchanged
        end
    end

endmodule