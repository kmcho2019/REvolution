module TopModule (
    input clk,
    input areset,

    // Prediction interface
    input predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    // Training interface
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 2-bit saturating counter states
    // 2'b00 = Strongly not taken
    // 2'b01 = Weakly not taken
    // 2'b10 = Weakly taken
    // 2'b11 = Strongly taken

    reg [1:0] PHT [0:127];
    reg [6:0] global_history;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT state for prediction
    wire [1:0] pht_counter = PHT[predict_index];

    // Output predicted taken (MSB of counter)
    assign predict_taken = predict_valid ? pht_counter[1] : 1'b0;
    assign predict_history = global_history;

    // Update PHT at clock edge when training valid
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (i=0; i<128; i=i+1) begin
                // Initialize to weakly taken (2'b10)
                PHT[i] <= 2'b10;
            end
        end else begin
            // Update PHT when training valid
            if (train_valid) begin
                case (PHT[train_index])
                    2'b00: PHT[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: PHT[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: PHT[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: PHT[train_index] <= train_taken ? 2'b11 : 2'b10;
                    default: PHT[train_index] <= 2'b10;
                endcase
            end

            // Update global history
            // Training mispredict has precedence: recover history to train_history
            if (train_valid && train_mispredicted) begin
                global_history <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted taken bit
                global_history <= {global_history[5:0], pht_counter[1]};
            end
            // Else global_history unchanged
        end
    end

endmodule