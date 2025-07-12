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

reg [6:0] ghr; // global branch history register
reg [6:0] ghr_next; // next state of ghr
reg [1:0] pht [127:0]; // pattern history table
reg [1:0] pht_next [127:0]; // next state of pht

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        ghr <= ghr_next;
        for (i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    ghr_next = ghr;
    for (i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end

    if (predict_valid) begin
        // calculate the index for the pht
        integer index;
        index = {predict_pc[6:1], ghr[0]} ^ ghr;
        index = index % 128;
        
        // produce the predicted branch direction
        if (pht[index] == 2'b00 || pht[index] == 2'b01) begin
            predict_taken = 1'b0;
        end else begin
            predict_taken = 1'b1;
        end
        
        // produce the current state of the branch history register
        predict_history = ghr;
        
        // update the branch history register
        if (predict_taken) begin
            ghr_next[6:1] = ghr[5:0];
            ghr_next[0] = 1'b1;
        end else begin
            ghr_next[6:1] = ghr[5:0];
            ghr_next[0] = 1'b0;
        end
    end

    if (train_valid) begin
        // calculate the index for the pht
        integer index;
        index = {train_pc[6:1], train_history[0]} ^ train_history;
        index = index % 128;
        
        // update the pht
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht_next[index] = pht[index] + 1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht_next[index] = pht[index] - 1;
            end
        end
        
        // recover the branch history register if misprediction occurred
        if (train_mispredicted) begin
            ghr_next = train_history;
        end
    end
end

endmodule