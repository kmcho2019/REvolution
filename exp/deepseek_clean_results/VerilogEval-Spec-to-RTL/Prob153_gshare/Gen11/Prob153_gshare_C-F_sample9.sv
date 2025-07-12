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

    parameter PHT_SIZE = 128;
    parameter PHT_WIDTH = 2;
    parameter INIT_COUNTER = 2'b01;  // Weakly taken

    // Function to update saturating counter (optimized)
    function [PHT_WIDTH-1:0] update_counter;
        input [PHT_WIDTH-1:0] current;
        input taken;
        begin
            update_counter = taken ? 
                (current == {PHT_WIDTH{1'b1}} ? current : current + 1 :
                (current == 0) ? 0 : current - 1;
        end
    endfunction

    // Pattern History Table
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];
    
    // Global History Register
    reg [6:0] ghr;
    reg [6:0] next_ghr;
    
    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][PHT_WIDTH-1];  // MSB determines prediction
    assign predict_history = ghr;
    
    // Training path (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    
    // GHR update logic (priority to training)
    always @(*) begin
        casez ({train_valid && train_mispredicted, predict_valid})
            2'b1?: next_ghr = {train_history[5:0], train_taken};
            2'b01: next_ghr = {ghr[5:0], predict_taken};
            default: next_ghr = ghr;
        endcase
    end
    
    // Sequential updates
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT
            for (i = 0; i < PHT_SIZE; i = i + 1)
                pht[i] <= INIT_COUNTER;
            ghr <= 7'b0;
        end else begin
            // Update PHT if training
            if (train_valid)
                pht[train_index] <= update_counter(pht[train_index], train_taken);
            
            // Update GHR
            ghr <= next_ghr;
        end
    end

endmodule