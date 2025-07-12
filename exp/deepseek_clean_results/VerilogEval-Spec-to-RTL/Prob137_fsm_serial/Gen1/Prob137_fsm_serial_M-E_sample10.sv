module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    reg [9:0] frame_reg;  // Stores start + 8 data + stop bits
    reg [3:0] bit_count;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 10'b1111111111;  // Initialize to idle state
            bit_count <= 4'b0;
            done_reg <= 1'b0;
        end else begin
            // Shift in new bit
            frame_reg <= {frame_reg[8:0], in};
            
            // Increment counter when not idle, reset when frame complete
            if (bit_count == 4'd10) begin
                bit_count <= 4'd0;
            end else if (bit_count > 0 || (bit_count == 0 && in == 0)) begin
                bit_count <= bit_count + 1;
            end

            // Check for valid frame (start=0, stop=1) when counter reaches 10
            done_reg <= (bit_count == 4'd10) && (frame_reg[9] == 0) && (frame_reg[0] == 1);
        end
    end

    assign done = done_reg;

endmodule