module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [7:0] msb;  // Most significant 8 bits
reg [7:0] lsb;  // Least significant 8 bits

always @ (posedge clk) begin
    if (reset) begin
        msb <= 8'd0;
        lsb <= 8'd0;
    end else begin
        // Update LSBs synchronously
        if (up_down) begin
            if (lsb == 8'd255) begin
                msb <= msb + 1;
                lsb <= 8'd0;
            end else begin
                lsb <= lsb + 1;
            end
        end else begin
            if (lsb == 8'd0) begin
                if (msb == 8'd0) begin
                    msb <= 8'd255;
                    lsb <= 8'd255;
                end else begin
                    msb <= msb - 1;
                    lsb <= 8'd255;
                end
            end else begin
                lsb <= lsb - 1;
            end
        end
    end
end

always @ (*) begin
    // Combine MSBs and LSBs to form the final count
    count <= {msb, lsb};
end

endmodule