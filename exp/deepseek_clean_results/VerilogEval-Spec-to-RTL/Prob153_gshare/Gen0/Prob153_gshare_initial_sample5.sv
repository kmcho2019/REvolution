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

    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];
    
    // Branch History Register
    reg [6:0] bhr;
    
    // Prediction index and value
    wire [6:0] predict_index = predict_pc ^ bhr;
    wire [1:0] predict_counter = pht[predict_index];
    assign predict_taken = predict_counter[1];
    assign predict_history = bhr;
    
    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] train_counter;
    
    // Next BHR value
    reg [6:0] next_bhr;
    
    // Initialize PHT to weakly taken (01)
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1)
            pht[i] = 2'b01;
    end
    
    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bhr <= 7'b0;
        end else begin
            // Update BHR
            bhr <= next_bhr;
            
            // Update PHT for training
            if (train_valid) begin
                pht[train_index] <= train_counter;
            end
        end
    end
    
    // Combinational logic for next state
    always @(*) begin
        // Default: maintain current BHR
        next_bhr = bhr;
        
        // Handle training first (higher priority)
        if (train_valid) begin
            // Calculate new counter value
            train_counter = pht[train_index];
            if (train_taken) begin
                train_counter = (train_counter == 2'b11) ? 2'b11 : train_counter + 1;
            end else begin
                train_counter = (train_counter == 2'b00) ? 2'b00 : train_counter - 1;
            end
            
            // Update BHR for misprediction
            if (train_mispredicted) begin
                next_bhr = {train_history[5:0], train_taken};
            end
        end 
        // Then handle prediction if no training
        else if (predict_valid) begin
            next_bhr = {bhr[5:0], predict_taken};
        end
    end

endmodule