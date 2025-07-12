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

    // Function to calculate next PHT state
    function [1:0] next_pht_state;
        input [1:0] current;
        input taken;
        begin
            if (taken)
                next_pht_state = (current == 2'b11) ? 2'b11 : current + 1;
            else
                next_pht_state = (current == 2'b00) ? 2'b00 : current - 1;
        end
    endfunction

    // GHR and PHT registers
    reg [6:0] ghr;
    reg [1:0] pht [0:127];
    
    // Prediction is combinational
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Next state signals
    wire [1:0] next_pht = next_pht_state(pht[train_index], train_taken);
    wire [6:0] next_ghr = (train_valid && train_mispredicted) ? {train_history[5:0], train_taken} :
                          (predict_valid) ? {ghr[5:0], predict_taken} :
                          ghr;
    
    // PHT initialization using generate
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin: pht_init
            always @(posedge clk or posedge areset) begin
                if (areset) begin
                    pht[i] <= 2'b01;
                end else if (train_valid && (train_index == i)) begin
                    pht[i] <= next_pht;
                end
            end
        end
    endgenerate

    // GHR update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else if (train_valid && train_mispredicted) begin
            ghr <= {train_history[5:0], train_taken};
        end else if (predict_valid) begin
            ghr <= {ghr[5:0], predict_taken};
        end
    end

endmodule