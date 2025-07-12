module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    // Internal counter register
    reg [2:0] counter;

    // Update counter on each clock pulse
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset counter to initial value
            counter <= 0;
        end else begin
            // Increment counter
            counter <= counter + 1;
            if (counter == 8 - 1) begin
                // Wrap counter around after reaching maximum value
                counter <= 0;
            end
        end
    end

    // Update output based on counter value
    always @(*) begin
        case (counter)
            3'b000: out = 8'b0000_0001;
            3'b001: out = 8'b0000_0010;
            3'b010: out = 8'b0000_0100;
            3'b011: out = 8'b0000_1000;
            3'b100: out = 8'b0001_0000;
            3'b101: out = 8'b0010_0000;
            3'b110: out = 8'b0100_0000;
            3'b111: out = 8'b1000_0000;
            default: out = 8'b0000_0000;
        endcase
    end

endmodule