module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000001;  // Initialize with LSB '1'
        end else begin
            // Rotate the bits to the left by 1 with wrap-around
            // out[7] takes previous out[0], out[0] takes previous out[1], etc.
            out[7] <= out[0];
            out[6] <= out[7];
            out[5] <= out[6];
            out[4] <= out[5];
            out[3] <= out[4];
            out[2] <= out[3];
            out[1] <= out[2];
            out[0] <= out[1];
        end
    end

endmodule