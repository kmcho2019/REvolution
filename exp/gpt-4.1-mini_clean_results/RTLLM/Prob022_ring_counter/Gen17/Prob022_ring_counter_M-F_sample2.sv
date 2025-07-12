module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize out to 00000001 by setting each bit individually
            out[0] <= 1'b1;
            for (i = 1; i < 8; i = i + 1) begin
                out[i] <= 1'b0;
            end
        end else begin
            if (out[7] == 1'b0) begin
                // Shift left by one bit with one-hot behavior
                // Assign each bit individually to avoid full vector assignment
                out[0] <= out[1];
                for (i = 1; i < 7; i = i + 1) begin
                    out[i] <= out[i+1];
                end
                out[7] <= 1'b0;
            end else begin
                // MSB is 1, wrap around: shift left and set LSB to 1
                out[0] <= 1'b1;
                for (i = 1; i < 8; i = i + 1) begin
                    out[i] <= 1'b0;
                end
            end
        end
    end

endmodule