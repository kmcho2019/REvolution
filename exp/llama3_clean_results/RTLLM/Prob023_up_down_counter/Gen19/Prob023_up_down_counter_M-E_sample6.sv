// Define a module for binary to gray code conversion
module bin_to_gray (
    input [15:0] bin_value,
    output reg [15:0] gray_value
);

always @ (*) begin
    gray_value = (bin_value >> 1) ^ bin_value;
end

endmodule

// Define a module for gray to binary code conversion
module gray_to_bin (
    input [15:0] gray_value,
    output reg [15:0] bin_value
);

always @ (*) begin
    bin_value = gray_value;
    for (int i = 0; i < 15; i++) begin
        bin_value = (bin_value >> 1) ^ bin_value;
    end
end

endmodule

// Define the main up_down_counter module
module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] next_count;
reg [15:0] gray_count;

// Instantiate the binary to gray code conversion module
bin_to_gray bin_to_gray_instance (
    .bin_value(count),
    .gray_value(gray_count)
);

// Update the counter state on the rising edge of the clock signal
always @ (posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (up_down) begin
        // Increment the counter in binary mode
        count <= count + 1;
    end else begin
        // Decrement the counter in gray code mode
        gray_count <= gray_count - 1;
        gray_to_bin gray_to_bin_instance (
            .gray_value(gray_count),
            .bin_value(next_count)
        );
        count <= next_count;
    end
end

endmodule