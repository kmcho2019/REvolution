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

    // Parameters
    localparam PHT_SIZE = 128;
    localparam PHT_WIDTH = 2;
    
    // Pattern History Table (2-bit saturating counters)
    reg [PHT_WIDTH-1:0] pht [0:PHT_SIZE-1];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Shared XOR for both prediction and training paths
    wire [6:0] current_index = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);
    
    // Prediction output
    assign predict_taken = pht[predict_pc ^ ghr][1];
    assign predict_history = ghr;
    
    // Next state signals
    reg [6:0] next_ghr;
    reg [PHT_WIDTH-1:0] next_pht;
    reg pht_update_en;
    reg [6:0] pht_update_addr;

    // Combinational next state logic
    always @(*) begin
        // Default holds current values
        next_ghr = ghr;
        next_pht = 2'b00;
        pht_update_en = 1'b0;
        pht_update_addr = current_index;
        
        // Priority: training misprediction > training > prediction
        if (train_valid) begin
            if (train_mispredicted) begin
                next_ghr = {train_history[5:0], train_taken};
            end
            
            // Calculate PHT update
            pht_update_en = 1'b1;
            case (pht[current_index])
                2'b00: next_pht = train_taken ? 2'b01 : 2'b00;
                2'b01: next_pht = train_taken ? 2'b10 : 2'b00;
                2'b10: next_pht = train_taken ? 2'b11 : 2'b01;
                2'b11: next_pht = train_taken ? 2'b11 : 2'b10;
            endcase
        end
        else if (predict_valid) begin
            next_ghr = {ghr[5:0], predict_taken};
        end
    end

    // Sequential update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Update GHR
            ghr <= next_ghr;
            
            // Update PHT if needed
            if (pht_update_en) begin
                pht[pht_update_addr] <= next_pht;
            end
        end
    end

endmodule