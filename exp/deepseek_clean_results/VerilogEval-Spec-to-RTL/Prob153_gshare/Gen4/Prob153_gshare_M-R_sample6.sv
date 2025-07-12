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

    // State declarations
    reg [6:0] ghr;
    reg [1:0] pht [0:127];
    
    // Initialize PHT (synthesis will ignore this, simulation uses it)
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            pht[i] = 2'b10;  // Weakly taken
        end
    end

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_counter = pht[train_index];
    wire [1:0] updated_counter = 
        !train_valid ? current_counter :
        train_taken ? (current_counter == 2'b11 ? 2'b11 : current_counter + 1) :
                     (current_counter == 2'b00 ? 2'b00 : current_counter - 1);

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b10;  // Weakly taken
            end
        end else begin
            // PHT update
            if (train_valid) begin
                pht[train_index] <= updated_counter;
            end
            
            // GHR update - training has strict priority
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule