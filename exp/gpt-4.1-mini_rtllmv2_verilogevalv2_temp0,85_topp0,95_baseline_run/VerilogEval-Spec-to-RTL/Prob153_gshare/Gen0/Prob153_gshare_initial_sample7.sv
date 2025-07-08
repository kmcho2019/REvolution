module TopModule (
    input clk,
    input areset,

    // Prediction interface
    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    // Training interface
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    // Counter encoding: 2'b00: strongly not taken
    //                   2'b01: weakly not taken
    //                   2'b10: weakly taken
    //                   2'b11: strongly taken
    // Initialize to weakly taken (2'b10)
    reg [1:0] pht [0:127];

    // Global History Register (7 bits)
    reg [6:0] global_history;

    // Calculate indices
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entry for prediction (combinational)
    wire [1:0] predict_counter = pht[predict_index];

    // For prediction output before next clock
    wire predict_taken_next = predict_counter[1]; // MSB = 1 means taken

    // Prediction history output is global_history before update
    // This is output combinationally on predict_valid, else don't change output
    always @(*) begin
        predict_taken = 1'b0;
        predict_history = 7'b0;
        if (predict_valid) begin
            predict_taken = predict_taken_next;
            predict_history = global_history;
        end
    end

    integer i;

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // async reset
            global_history <= 7'b0;
            for (i=0; i<128; i=i+1)
                pht[i] <= 2'b10; // weakly taken
        end else begin
            // Training updates take precedence
            if (train_valid) begin
                // Update PHT entry at train_index according to train_taken
                case (pht[train_index])
                    2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                    default: pht[train_index] <= 2'b10;
                endcase

                // If mispredicted, recover global history to train_history
                if (train_mispredicted) begin
                    global_history <= train_history;
                end else begin
                    // If no misprediction, update global history by appending train_taken
                    // Shift left, insert train_taken at LSB
                    global_history <= {global_history[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // No training this cycle, update global history using predicted taken
                // Only if no training, else training takes precedence
                global_history <= {global_history[5:0], predict_taken_next};
            end
            // else no change to global_history or PHT
        end
    end

endmodule