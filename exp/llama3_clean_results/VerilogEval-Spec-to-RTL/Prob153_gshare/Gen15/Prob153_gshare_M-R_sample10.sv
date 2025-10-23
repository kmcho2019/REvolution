module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] global_history;
reg [1:0] pht [127:0];

wire [6:0] predict_index;
wire [6:0] train_index;

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

// Combinational logic to determine the next state of the global history
wire [6:0] next_global_history;
assign next_global_history = (train_mispredicted && train_valid)? train_history : 
                             ({global_history[5:0], train_taken} && train_valid)? 
                             {global_history[5:0], train_taken} : 
                             (predict_valid &&!train_valid)? 
                             {global_history[5:0], predict_taken} : global_history;

// Combinational logic to determine the next state of the pht
wire [1:0] next_pht [127:0];
genvar i;
generate
    for (i = 0; i < 128; i++) begin
        always @(*) begin
            if (train_valid && (train_index == i)) begin
                if (train_taken) begin
                    if (pht[i] == 2'b11) begin
                        next_pht[i] = 2'b11;
                    end else begin
                        next_pht[i] = pht[i] + 1'b1;
                    end
                end else begin
                    if (pht[i] == 2'b00) begin
                        next_pht[i] = 2'b00;
                    end else begin
                        next_pht[i] = pht[i] - 1'b1;
                    end
                end
            end else begin
                next_pht[i] = pht[i];
            end
        end
    end
endgenerate

// Sequential logic to update the global history and pht
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        global_history <= next_global_history;
        predict_history <= global_history;
        if (predict_valid &&!train_valid) begin
            predict_taken <= (pht[predict_index] >= 2'b10)? 1'b1 : 1'b0;
        end
        for (int i = 0; i < 128; i++) begin
            pht[i] <= next_pht[i];
        end
    end
end

endmodule