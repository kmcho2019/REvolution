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

    // Dual-ported PHT (128x2 bits)
    reg [1:0] pht [0:127];
    wire [1:0] pht_read_data;
    reg [6:0] pht_read_addr;
    reg pht_write_en;
    reg [6:0] pht_write_addr;
    reg [1:0] pht_write_data;

    // GHR registers
    reg [6:0] speculative_ghr;
    reg [6:0] confirmed_ghr;
    
    // GHR recovery stack (4 entries)
    reg [6:0] ghr_stack [0:3];
    reg [1:0] stack_ptr;

    // Training queue
    reg train_queued;
    reg queued_train_taken;
    reg [6:0] queued_train_pc;
    reg [6:0] queued_train_history;

    // Prediction index calculation
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = confirmed_ghr;

    // PHT read port
    always @(*) begin
        pht_read_addr = predict_index;
    end

    // PHT write port
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            speculative_ghr <= 7'b0;
            confirmed_ghr <= 7'b0;
            stack_ptr <= 2'b0;
            train_queued <= 1'b0;
        end else begin
            // Handle training requests (priority over predictions)
            if (train_valid || train_queued) begin
                // Update PHT
                pht_write_en <= 1'b1;
                pht_write_addr <= train_valid ? (train_pc ^ train_history) : 
                                              (queued_train_pc ^ queued_train_history);
                pht_write_data <= (train_valid ? train_taken : queued_train_taken) ? 
                                 ((pht[pht_write_addr] == 2'b11) ? 2'b11 : pht[pht_write_addr] + 1 :
                                 ((pht[pht_write_addr] == 2'b00) ? 2'b00 : pht[pht_write_addr] - 1);

                // Handle misprediction recovery
                if ((train_valid && train_mispredicted) || 
                    (train_queued && train_mispredicted)) begin
                    confirmed_ghr <= {train_valid ? train_history : queued_train_history, 
                                    train_valid ? train_taken : queued_train_taken};
                    speculative_ghr <= confirmed_ghr;
                    // Push to recovery stack
                    ghr_stack[stack_ptr] <= confirmed_ghr;
                    stack_ptr <= stack_ptr + 1;
                end

                // Clear queued training if processed
                if (train_valid) begin
                    train_queued <= 1'b0;
                end
            end else if (predict_valid) begin
                // Speculative GHR update
                speculative_ghr <= {speculative_ghr[5:0], predict_taken};
                // Push to recovery stack if no pending training
                if (!train_queued) begin
                    confirmed_ghr <= {confirmed_ghr[5:0], predict_taken};
                end
            end

            // Queue training if conflict occurs
            if (train_valid && predict_valid && 
                (train_pc ^ train_history) == (predict_pc ^ speculative_ghr)) begin
                train_queued <= 1'b1;
                queued_train_taken <= train_taken;
                queued_train_pc <= train_pc;
                queued_train_history <= train_history;
            end
        end
    end

endmodule