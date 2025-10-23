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
    parameter GHR_WIDTH = 7;

    // Function to update saturating counter (from Example 1)
    function [PHT_WIDTH-1:0] update_counter;
        input [PHT_WIDTH-1:0] current;
        input taken;
        begin
            if (taken) begin
                update_counter = (current == {PHT_WIDTH{1'b1}}) ? 
                               current : current + 1;
            end else begin
                update_counter = (current == 0) ? 0 : current - 1;
            end
        end
    endfunction

    // Global history register
    reg [GHR_WIDTH-1:0] ghr;
    // Pattern history table
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];

    // Prediction index and output (combinational)
    wire [GHR_WIDTH-1:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][PHT_WIDTH-1]; // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [GHR_WIDTH-1:0] train_index = train_pc ^ train_history;

    // Next GHR value (combinational, priority handled)
    wire [GHR_WIDTH-1:0] next_ghr = (train_valid && train_mispredicted) ? 
                                   {train_history[GHR_WIDTH-2:0], train_taken} :
                                   (predict_valid) ? 
                                   {ghr[GHR_WIDTH-2:0], predict_taken} :
                                   ghr;

    // PHT update logic (using generate block from Example 2)
    wire [PHT_WIDTH-1:0] next_pht [0:PHT_SIZE-1];
    genvar i;
    generate
        for (i = 0; i < PHT_SIZE; i = i + 1) begin : pht_update
            // Only update the entry being trained
            assign next_pht[i] = (train_valid && (train_index == i)) ? 
                                update_counter(pht[i], train_taken) : 
                                pht[i];
        end
    endgenerate

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= {GHR_WIDTH{1'b0}};
            for (integer j = 0; j < PHT_SIZE; j = j + 1) begin
                pht[j] <= {1'b0, 1'b1};  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT only if training occurred (power optimization)
            if (train_valid) begin
                pht[train_index] <= next_pht[train_index];
            end
        end
    end

endmodule