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

    // Main and shadow PHTs
    reg [1:0] main_pht [0:127];
    reg [1:0] shadow_pht [0:127];
    
    // Circular GHR implementation
    reg [6:0] ghr;
    reg [6:0] ghr_commit;  // Committed GHR state
    reg [2:0] ghr_ptr;     // Circular pointer
    
    // Prediction FIFO (stores indices of pending predictions)
    reg [6:0] pred_fifo [0:3];
    reg [1:0] fifo_wptr, fifo_rptr;
    reg fifo_full;
    
    // Prediction path
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? main_pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    
    // FIFO management
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            fifo_wptr <= 0;
            fifo_rptr <= 0;
            fifo_full <= 0;
        end else begin
            // FIFO write (on prediction)
            if (predict_valid && !fifo_full) begin
                pred_fifo[fifo_wptr] <= predict_index;
                fifo_wptr <= fifo_wptr + 1;
                fifo_full <= (fifo_wptr + 1 == fifo_rptr);
            end
            
            // FIFO read (on training)
            if (train_valid && !(fifo_rptr == fifo_wptr && !fifo_full)) begin
                fifo_rptr <= fifo_rptr + 1;
                fifo_full <= 0;
            end
        end
    end
    
    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHTs to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1) begin
                main_pht[i] <= 2'b01;
                shadow_pht[i] <= 2'b01;
            end
            
            // Initialize GHR
            ghr <= 0;
            ghr_commit <= 0;
            ghr_ptr <= 0;
        end else begin
            // Training updates to shadow PHT
            if (train_valid) begin
                case (shadow_pht[train_index])
                    2'b00: shadow_pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: shadow_pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: shadow_pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: shadow_pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
                
                // On misprediction, roll back GHR
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                    ghr_ptr <= 0;
                end
            end
            
            // Prediction updates to GHR (circular buffer style)
            if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr[ghr_ptr] <= predict_taken;
                ghr_ptr <= ghr_ptr + 1;
            end
            
            // Periodic PHT merge (every 4 cycles when FIFO empty)
            if (fifo_rptr == fifo_wptr && !fifo_full) begin
                for (integer i = 0; i < 128; i = i + 1) begin
                    main_pht[i] <= shadow_pht[i];
                end
            end
        end
    end

endmodule