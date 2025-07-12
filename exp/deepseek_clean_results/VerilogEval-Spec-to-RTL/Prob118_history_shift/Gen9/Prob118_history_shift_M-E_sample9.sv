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

    reg [4:0] wr_ptr;  // 32-entry circular buffer (5-bit pointer)
    reg [63:0] buffer; // Double buffer size for easy circular access
    reg [31:0] saved_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            wr_ptr <= 0;
            buffer <= 0;
            saved_history <= 0;
        end else if (train_mispredicted) begin
            // Load history and append actual taken
            buffer <= {train_history, train_taken, 31'b0};
            wr_ptr <= 32;  // Points to position after train_taken
            saved_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Circular write
            buffer[wr_ptr] <= predict_taken;
            wr_ptr <= wr_ptr + 1;
            saved_history <= {saved_history[30:0], predict_taken};
        end
    end

    // Circular read - output the 32 bits ending at wr_ptr-1
    assign predict_history = saved_history;

endmodule