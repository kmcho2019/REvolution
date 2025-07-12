module TopModule (
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

    // Function to update saturating counter (optimized version)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = current ^ {taken, taken & ~(&current)};
        end
    endfunction

    // 7-bit global history register with gray coding
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];
    reg pht_update_en;

    // Shared XOR logic for index computation
    wire [6:0] xor_index = (train_valid ? train_pc : predict_pc) ^ 
                          (train_valid ? train_history : ghr);
    reg [6:0] reg_index;

    // Registered PHT output
    reg [1:0] pht_out;

    // Clock gating for PHT updates
    always @(*) begin
        pht_update_en = train_valid & ~areset;
    end

    // Index computation pipeline
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            reg_index <= 7'b0;
        end else begin
            reg_index <= xor_index;
        end
    end

    // PHT access and update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT (only initialize when needed)
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            pht_out <= 2'b01;
        end else begin
            // Register PHT output
            pht_out <= pht[reg_index];
            
            // Update PHT if enabled
            if (pht_update_en) begin
                pht[reg_index] <= update_counter(pht[reg_index], train_taken);
            end
        end
    end

    // Prediction output registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else if (predict_valid) begin
            predict_taken <= pht_out[1];
            predict_history <= ghr;
        end
    end

    // GHR update logic with gray coding
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // Training has priority over prediction
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken} ^ 
                      {1'b0, train_history[5:0] & train_history[4:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht_out[1]} ^ 
                      {1'b0, ghr[5:0] & ghr[4:0], pht_out[1]};
            end
        end
    end

endmodule