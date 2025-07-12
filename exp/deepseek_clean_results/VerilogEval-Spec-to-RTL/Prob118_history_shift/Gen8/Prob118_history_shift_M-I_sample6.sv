module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_buffer;
    reg [4:0] write_ptr;  // Points to next write position (0-31)
    wire update_en;
    wire [4:0] next_ptr;
    wire [31:0] next_history;

    // Update enable logic
    assign update_en = areset | train_mispredicted | predict_valid;

    // Next pointer calculation
    assign next_ptr = (areset) ? 5'b0 : 
                     (train_mispredicted) ? 5'b0 :
                     (write_ptr + 1'b1);

    // Next history calculation with priority
    assign next_history = (areset) ? 32'b0 :
                         (train_mispredicted) ? {train_history[30:0], train_taken} :
                         {history_buffer[30:0], predict_taken};

    // Clock-gated register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_buffer <= 32'b0;
            write_ptr <= 5'b0;
        end else if (update_en) begin
            history_buffer <= next_history;
            write_ptr <= next_ptr;
        end
    end

    // Circular buffer readout (no shifting needed)
    assign predict_history = history_buffer;

endmodule