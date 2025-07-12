module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] hist_mem;
    reg [4:0]  write_ptr;  // points to youngest branch index (0..31)

    // Compute the output by "rotating" hist_mem so that predict_history[0] is youngest
    // The youngest bit is at write_ptr - 1 modulo 32 (since write_ptr points to where next bit will be written)
    wire [4:0] oldest_ptr = write_ptr;
    integer i;
    reg [31:0] rotated_hist;

    always @(*) begin
        for (i = 0; i < 32; i = i + 1) begin
            // Map predict_history[i] = hist_mem[(write_ptr + i) % 32]
            rotated_hist[i] = hist_mem[(write_ptr + i) % 32];
        end
    end

    assign predict_history = rotated_hist;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            hist_mem   <= 32'b0;
            write_ptr  <= 5'd0;
        end else if (train_mispredicted) begin
            // On misprediction, load corrected history:
            // load train_history plus train_taken as the youngest bit
            // store train_taken at position write_ptr (youngest)
            hist_mem <= {train_taken, train_history[31:1]}; // shifted right by 1, LSB replaced with train_taken
            // Reset pointer to 1 because youngest bit is at index 0 now, so next write at 1
            write_ptr <= 5'd1;
        end else if (predict_valid) begin
            // Write predict_taken at current write_ptr position
            hist_mem[write_ptr] <= predict_taken;
            // Advance pointer modulo 32
            write_ptr <= (write_ptr == 5'd31) ? 5'd0 : write_ptr + 1;
        end
        // else hold values
    end

endmodule