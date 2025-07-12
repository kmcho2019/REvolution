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

    // Single GHR with rollback buffer
    reg [6:0] ghr;
    reg [6:0] ghr_rollback;
    reg rollback_pending;
    
    // 2-way PHT (64x2 bits per way)
    reg [1:0] pht [0:1][0:63];
    reg pht_clock_gate;
    
    // Pipelined prediction path
    reg [6:0] predict_index_reg;
    reg predict_valid_reg;
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire predict_way = predict_index[6];
    
    assign predict_taken = predict_valid_reg ? 
                         pht[predict_way][predict_index_reg[5:0]][1] : 1'b0;
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    wire train_way = train_index[6];
    reg [1:0] next_counter_state [0:1];
    
    // Shared next state logic for both ways
    always @(*) begin
        for (integer i = 0; i < 2; i = i + 1) begin
            case (pht[i][train_index[5:0]])
                2'b00: next_counter_state[i] = train_taken ? 2'b01 : 2'b00;
                2'b01: next_counter_state[i] = train_taken ? 2'b10 : 2'b00;
                2'b10: next_counter_state[i] = train_taken ? 2'b11 : 2'b01;
                2'b11: next_counter_state[i] = train_taken ? 2'b11 : 2'b10;
            endcase
        end
    end
    
    // Clock gating control
    always @(*) begin
        pht_clock_gate = ~(predict_valid | train_valid);
    end
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            ghr_rollback <= 7'b0;
            rollback_pending <= 1'b0;
            
            // Initialize PHT to weakly not-taken
            for (integer w = 0; w < 2; w = w + 1) begin
                for (integer i = 0; i < 64; i = i + 1) begin
                    pht[w][i] <= 2'b01;
                end
            end
        end else begin
            // Pipeline register
            predict_index_reg <= predict_index[5:0];
            predict_valid_reg <= predict_valid;
            
            // Handle misprediction rollback first
            if (rollback_pending) begin
                ghr <= ghr_rollback;
                rollback_pending <= 1'b0;
            end
            
            // Training updates
            if (train_valid && !pht_clock_gate) begin
                pht[train_way][train_index[5:0]] <= next_counter_state[train_way];
                
                if (train_mispredicted) begin
                    ghr_rollback <= {train_history[5:0], train_taken};
                    rollback_pending <= 1'b1;
                end
            end
            
            // GHR update (speculative)
            if (predict_valid && !rollback_pending) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule