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

    // Single GHR with rollback capability
    reg [6:0] ghr;
    reg [6:0] ghr_backup;  // Stores GHR before prediction for possible rollback
    
    // PHT memory
    reg [1:0] pht [0:127];
    
    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;
    
    // Training path (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] next_counter_state;
    
    // PHT update logic using case statement
    always @(*) begin
        case (pht[train_index])
            2'b00: next_counter_state = train_taken ? 2'b01 : 2'b00;
            2'b01: next_counter_state = train_taken ? 2'b10 : 2'b00;
            2'b10: next_counter_state = train_taken ? 2'b11 : 2'b01;
            2'b11: next_counter_state = train_taken ? 2'b11 : 2'b10;
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR to 0
            ghr <= 7'b0;
            ghr_backup <= 7'b0;
            
            // Initialize PHT to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            // Backup GHR before prediction updates
            if (predict_valid)
                ghr_backup <= ghr;
            
            // Training has priority
            if (train_valid) begin
                // Update PHT
                pht[train_index] <= next_counter_state;
                
                // On misprediction, restore GHR from training history
                if (train_mispredicted)
                    ghr <= {train_history[5:0], train_taken};
            end 
            // Normal prediction update (if no training or no misprediction)
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule