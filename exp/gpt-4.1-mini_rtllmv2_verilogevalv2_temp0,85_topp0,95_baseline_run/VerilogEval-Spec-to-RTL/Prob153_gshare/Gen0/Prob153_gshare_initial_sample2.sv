module TopModule(
    input        clk,
    input        areset,

    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // 2-bit saturating counter states encoding (0..3)
    // 0,1 -> not taken; 2,3 -> taken
    // Init to weakly taken (2)
    reg [1:0] PHT [0:127];
    integer i;

    // Global History Register (7-bit)
    reg [6:0] ghr;
    reg [6:0] ghr_next;

    // Index generation function
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries (combinational)
    wire [1:0] pht_predict_value = PHT[predict_index];
    wire [1:0] pht_train_value   = PHT[train_index]; // Used only for completeness, not read-modify-write here

    // Prediction output
    assign predict_taken   = (pht_predict_value[1] == 1'b1);
    assign predict_history = ghr;

    // Next GHR value after prediction update (shift left and insert predicted bit)
    wire [6:0] ghr_predicted_update = {ghr[5:0], predict_taken};

    // Internal registers to hold PHT update values
    reg [1:0] pht_updated_value;
    reg [6:0] pht_updated_index;
    reg       pht_update_en;

    // Update PHT entry function: saturating counter update based on actual branch outcome
    function [1:0] saturating_update;
        input [1:0] counter;
        input       taken;
        begin
            if(taken) begin
                // increment saturating counter but max at 3
                if(counter != 2'b11)
                    saturating_update = counter + 1;
                else
                    saturating_update = counter;
            end else begin
                // decrement saturating counter but min at 0
                if(counter != 2'b00)
                    saturating_update = counter - 1;
                else
                    saturating_update = counter;
            end
        end
    endfunction

    // Combinational logic for PHT update
    always @(*) begin
        pht_update_en = 1'b0;
        pht_updated_index = 7'd0;
        pht_updated_value = 2'd0;

        if(train_valid) begin
            pht_update_en = 1'b1;
            pht_updated_index = train_index;
            pht_updated_value = saturating_update(PHT[train_index], train_taken);
        end
    end

    // Update logic at posedge clk or async reset
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            ghr <= 7'd0;
            for(i=0; i<128; i=i+1) begin
                PHT[i] <= 2'b10; // weakly taken
            end
        end else begin
            // PHT update
            if(pht_update_en) begin
                PHT[pht_updated_index] <= pht_updated_value;
            end

            // GHR update:
            // If train_valid & train_mispredicted: restore GHR to train_history (training takes priority)
            // Else if predict_valid: update GHR with predicted taken bit
            if(train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if(predict_valid) begin
                ghr <= ghr_predicted_update;
            end
            // else keep GHR unchanged
        end
    end

endmodule