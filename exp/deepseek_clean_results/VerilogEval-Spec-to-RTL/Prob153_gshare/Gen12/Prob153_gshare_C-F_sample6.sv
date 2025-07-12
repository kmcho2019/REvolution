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

    // Function for saturating counter update (from Example 2)
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            if (taken) begin
                update_counter = (current == 2'b11) ? 2'b11 : current + 1;
            end else begin
                update_counter = (current == 2'b00) ? 2'b00 : current - 1;
            end
        end
    endfunction

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Continuous assignments for prediction (from Example 2)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT update logic (structured like Example 2 but efficient like Example 1)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not-taken (01)
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else if (train_valid) begin
            // Update PHT using function for cleaner code
            pht[train_index] <= update_counter(pht[train_index], train_taken);
        end
    end

    // GHR update logic (efficient like Example 1 but structured like Example 2)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // Training has priority (from Example 1)
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule