module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    reg [10:0] frame_reg;  // [10]:start, [9:2]:data, [1:0]:stop+valid
    reg [3:0] bit_counter;
    wire frame_complete;

    // Shift register and counter
    always @(posedge clk) begin
        if (reset) begin
            frame_reg <= 11'b0;
            bit_counter <= 4'b0;
        end else begin
            // Shift in new bit
            frame_reg <= {in, frame_reg[10:1]};
            
            // Update counter
            if (bit_counter == 4'd10) begin
                bit_counter <= 4'b0;
            end else begin
                bit_counter <= bit_counter + 1;
            end
        end
    end

    // Frame is complete when we've received 11 bits
    assign frame_complete = (bit_counter == 4'd10);

    // Done is asserted when:
    // 1. Frame is complete
    // 2. Start bit is 0 (frame_reg[10])
    // 3. Stop bit is 1 (frame_reg[0])
    assign done = frame_complete & ~frame_reg[10] & frame_reg[0];

endmodule