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

    // Dual-ported PHT (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Dual GHR implementation
    reg [6:0] predict_ghr;  // For prediction path
    reg [6:0] train_ghr;    // For training path
    
    // Prediction path
    wire [6:0] predict_index = predict_pc ^ predict_ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = predict_ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Counter update function
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            case (current)
                2'b00: update_counter = taken ? 2'b01 : 2'b00;
                2'b01: update_counter = taken ? 2'b10 : 2'b00;
                2'b10: update_counter = taken ? 2'b11 : 2'b01;
                2'b11: update_counter = taken ? 2'b11 : 2'b10;
            endcase
        end
    endfunction
    
    // GHR update mux
    reg [6:0] next_predict_ghr;
    always @(*) begin
        if (train_valid && train_mispredicted) begin
            next_predict_ghr = {train_history[5:0], train_taken};
        end else if (predict_valid) begin
            next_predict_ghr = {predict_ghr[5:0], predict_taken};
        end else begin
            next_predict_ghr = predict_ghr;
        end
    end
    
    // Initialize and update state
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            predict_ghr <= 7'b0;
            train_ghr <= 7'b0;
        end else begin
            // Update PHT for training
            if (train_valid)
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            
            // Update training GHR
            if (train_valid)
                train_ghr <= {train_ghr[5:0], train_taken};
            
            // Update prediction GHR with priority to misprediction recovery
            predict_ghr <= next_predict_ghr;
        end
    end

endmodule