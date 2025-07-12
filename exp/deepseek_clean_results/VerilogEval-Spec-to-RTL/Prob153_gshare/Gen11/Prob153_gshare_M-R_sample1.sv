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

    // Function for saturating counter update
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            update_counter = taken ? (current == 2'b11 ? 2'b11 : current + 1)
                                  : (current == 2'b00 ? 2'b00 : current - 1);
        end
    endfunction

    // PHT module
    wire [6:0] pht_index;
    wire [1:0] pht_out;
    wire pht_write_en;
    wire [1:0] pht_write_data;

    PHT pht (
        .clk(clk),
        .areset(areset),
        .index(pht_index),
        .read_data(pht_out),
        .write_en(pht_write_en),
        .write_data(pht_write_data)
    );

    // GHR module
    wire ghr_update_en;
    wire ghr_update_taken;
    wire [6:0] ghr_recovery_value;

    GHR ghr (
        .clk(clk),
        .areset(areset),
        .update_en(ghr_update_en),
        .update_taken(ghr_update_taken),
        .recovery_value(ghr_recovery_value),
        .current_value(predict_history)
    );

    // Prediction path
    wire [6:0] predict_index = predict_pc ^ predict_history;
    assign predict_taken = pht_out[1];
    assign pht_index = predict_valid ? predict_index : train_index;

    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    assign pht_write_en = train_valid;
    assign pht_write_data = update_counter(pht_out, train_taken);

    // GHR control logic
    assign ghr_update_en = (train_valid && train_mispredicted) || predict_valid;
    assign ghr_update_taken = train_valid && train_mispredicted ? train_taken : predict_taken;
    assign ghr_recovery_value = {train_history[5:0], train_taken};

endmodule

module PHT (
    input clk,
    input areset,
    input [6:0] index,
    output reg [1:0] read_data,
    input write_en,
    input [1:0] write_data
);
    reg [1:0] pht [0:127];

    always @(*) begin
        read_data = pht[index];
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else if (write_en) begin
            pht[index] <= write_data;
        end
    end
endmodule

module GHR (
    input clk,
    input areset,
    input update_en,
    input update_taken,
    input [6:0] recovery_value,
    output reg [6:0] current_value
);
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_value <= 7'b0;
        end else if (update_en) begin
            current_value <= (update_en && recovery_value[6]) ? 
                             recovery_value : 
                             {current_value[5:0], update_taken};
        end
    end
endmodule