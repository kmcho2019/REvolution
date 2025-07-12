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

    // Segment definitions
    localparam SEG1_BITS = 2;
    localparam SEG2_BITS = 2;
    localparam SEG3_BITS = 3;
    
    // Pattern History Table (banked 128 entries)
    reg [1:0] pht [0:127];
    
    // Segmented Global History Register
    reg [SEG1_BITS-1:0] ghr_seg1;
    reg [SEG2_BITS-1:0] ghr_seg2;
    reg [SEG3_BITS-1:0] ghr_seg3;
    
    // History recovery buffer
    reg [6:0] recovery_history;
    reg recovery_valid;
    
    // Dynamic hash selection signals
    wire [1:0] hash_sel = predict_pc[1:0];  // Use PC bits to select hash mode
    
    // Prediction index generation with dynamic segment selection
    wire [6:0] predict_index;
    assign predict_index = predict_pc ^ 
                         ((hash_sel == 2'b00) ? {ghr_seg3, ghr_seg2, ghr_seg1} :
                          (hash_sel == 2'b01) ? {ghr_seg1, ghr_seg3, ghr_seg2} :
                          (hash_sel == 2'b10) ? {ghr_seg2, ghr_seg1, ghr_seg3} :
                                                {ghr_seg3, ghr_seg1, ghr_seg2});
    
    // Training index (always uses full XOR)
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Output assignments
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = {ghr_seg3, ghr_seg2, ghr_seg1};
    
    // Next GHR calculation
    reg [6:0] next_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            next_ghr = recovery_valid ? recovery_history : {train_history[5:0], train_taken};
        end
        else if (predict_valid) begin
            next_ghr = {ghr_seg3[SEG3_BITS-2:0], ghr_seg2, ghr_seg1, predict_taken};
            // Cache intermediate state for possible recovery
            recovery_history = {ghr_seg3, ghr_seg2, ghr_seg1};
        end
        else begin
            next_ghr = {ghr_seg3, ghr_seg2, ghr_seg1};
        end
    end
    
    // Counter update function
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? 
                           (current == 2'b11 ? 2'b11 : current + 1) :
                           (current == 2'b00 ? 2'b00 : current - 1);
        end
    endfunction
    
    // Sequential logic
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr_seg1 <= 0;
            ghr_seg2 <= 0;
            ghr_seg3 <= 0;
            recovery_valid <= 0;
        end else begin
            // PHT update (training phase)
            if (train_valid)
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            
            // GHR update
            {ghr_seg3, ghr_seg2, ghr_seg1} <= next_ghr;
            
            // Recovery buffer management
            recovery_valid <= predict_valid;
        end
    end

endmodule