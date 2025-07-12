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

    // Segmented GHR (4+3 bits)
    reg [3:0] ghr_upper;
    reg [2:0] ghr_lower;
    wire [6:0] ghr = {ghr_upper, ghr_lower};

    // Dual-ported PHT (128x2 bits)
    reg [1:0] pht [0:127];
    
    // History recovery cache (stores last 4 GHR states)
    reg [6:0] recovery_cache [0:3];
    reg [1:0] cache_ptr;

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ {ghr_upper, ghr_lower};
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] updated_counter;

    // Speculative update tracking
    reg [6:0] spec_index;
    reg [1:0] spec_counter;
    reg spec_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all registers
            ghr_upper <= 4'b0;
            ghr_lower <= 3'b0;
            cache_ptr <= 2'b0;
            spec_valid <= 1'b0;
            
            // Initialize PHT to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            
            // Initialize recovery cache
            for (integer i = 0; i < 4; i = i + 1) begin
                recovery_cache[i] <= 7'b0;
            end
        end else begin
            // Handle training first (highest priority)
            if (train_valid) begin
                // Update PHT counter
                updated_counter = pht[train_index];
                if (train_taken) begin
                    updated_counter = (updated_counter == 2'b11) ? 2'b11 : updated_counter + 1;
                end else begin
                    updated_counter = (updated_counter == 2'b00) ? 2'b00 : updated_counter - 1;
                end
                pht[train_index] <= updated_counter;

                // Cancel any pending speculative update for this index
                if (spec_valid && (spec_index == train_index)) begin
                    spec_valid <= 1'b0;
                end

                // Handle misprediction recovery
                if (train_mispredicted) begin
                    {ghr_upper, ghr_lower} <= {train_history[5:0], train_taken};
                end
                
                // Store current GHR in recovery cache
                recovery_cache[cache_ptr] <= ghr;
                cache_ptr <= cache_ptr + 1;
            end
            
            // Handle prediction (medium priority)
            if (predict_valid && (!train_valid || !train_mispredicted)) begin
                // Perform speculative PHT update
                spec_index <= predict_index;
                spec_counter <= pht[predict_index];
                if (predict_taken) begin
                    spec_counter <= (pht[predict_index] == 2'b11) ? 2'b11 : pht[predict_index] + 1;
                end else begin
                    spec_counter <= (pht[predict_index] == 2'b00) ? 2'b00 : pht[predict_index] - 1;
                end
                spec_valid <= 1'b1;
                
                // Update segmented GHR
                ghr_upper <= {ghr_upper[2:0], predict_taken, ghr_upper[3]};
                ghr_lower <= {ghr_lower[1:0], predict_taken};
            end
            
            // Commit speculative updates (lowest priority)
            if (spec_valid && !train_valid) begin
                pht[spec_index] <= spec_counter;
                spec_valid <= 1'b0;
            end
        end
    end

endmodule