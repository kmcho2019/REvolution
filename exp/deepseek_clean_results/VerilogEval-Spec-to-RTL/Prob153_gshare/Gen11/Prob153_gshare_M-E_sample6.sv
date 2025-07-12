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

    // Dual-ported PHT structure
    reg [1:0] pht [0:127];
    reg [1:0] pht_read_data;
    reg [1:0] pht_write_data;
    reg [6:0] pht_write_addr;
    reg pht_write_en;

    // GHR with speculative next state
    reg [6:0] ghr_current;
    reg [6:0] ghr_next;
    reg ghr_update_en;

    // Prediction index and bypass logic
    wire [6:0] predict_index = predict_pc ^ ghr_current;
    wire [6:0] train_index = train_pc ^ train_history;
    wire bypass_active = (train_valid && (train_index == predict_index));
    wire [1:0] final_prediction = bypass_active ? 
        (train_taken ? {1'b1, ~(&pht_read_data)} : {1'b0, |pht_read_data}) : 
        pht_read_data;

    assign predict_taken = final_prediction[1];
    assign predict_history = ghr_current;

    // PHT read port (always enabled)
    always @(*) begin
        pht_read_data = pht[predict_index];
    end

    // PHT write port
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else if (pht_write_en) begin
            pht[pht_write_addr] <= pht_write_data;
        end
    end

    // Unified counter update logic
    always @(*) begin
        if (train_valid) begin
            pht_write_data = pht[train_index] + (train_taken ? 1 : -1);
            // Saturate at boundaries
            if (train_taken && &pht[train_index]) pht_write_data = 2'b11;
            if (!train_taken && !(|pht[train_index])) pht_write_data = 2'b00;
            pht_write_addr = train_index;
            pht_write_en = 1'b1;
        end else begin
            pht_write_data = 2'b00;
            pht_write_addr = 7'b0;
            pht_write_en = 1'b0;
        end
    end

    // GHR update logic with speculative tracking
    always @(*) begin
        ghr_next = ghr_current;
        ghr_update_en = 1'b0;

        if (train_valid && train_mispredicted) begin
            ghr_next = {train_history[5:0], train_taken};
            ghr_update_en = 1'b1;
        end else if (predict_valid) begin
            ghr_next = {ghr_current[5:0], final_prediction[1]};
            ghr_update_en = 1'b1;
        end
    end

    // GHR sequential update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_current <= 7'b0;
        end else if (ghr_update_en) begin
            ghr_current <= ghr_next;
        end
    end

endmodule