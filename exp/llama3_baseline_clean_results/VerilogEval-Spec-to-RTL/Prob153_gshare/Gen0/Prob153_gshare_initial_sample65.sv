module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    reg [6:0] gshare_history;
    reg [6:0] next_gshare_history;
    reg [1:0] pht [127:0];

    wire [6:0] predict_index;
    wire [6:0] train_index;
    wire predict_direction;

    assign predict_index = {predict_pc[6:1], predict_pc[0] ^ gshare_history[0]};
    assign train_index = {train_pc[6:1], train_pc[0] ^ train_history[0]};

    assign predict_direction = (pht[predict_index] == 2'b11 || pht[predict_index] == 2'b10);
    assign predict_taken = predict_direction;
    assign predict_history = gshare_history;

    always @(*) begin
        if(train_mispredicted)
            next_gshare_history = train_history;
        else if(predict_valid)
            next_gshare_history = {gshare_history[5:0], predict_taken};
        else
            next_gshare_history = gshare_history;
    end

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            gshare_history <= 7'd0;
            for(int i = 0; i < 128; i++)
                pht[i] <= 2'b01;
        end else begin
            gshare_history <= next_gshare_history;
            if(train_valid) begin
                if(train_taken)
                    pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
                else
                    pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
            end
        end
    end

endmodule