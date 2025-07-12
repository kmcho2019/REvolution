module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] ring_counter;
wire [3:0] encoded_out;

// Priority encoder to convert one-hot to binary
assign encoded_out = 
    ring_counter[9] ? 4'b1010 :  // 10
    ring_counter[8] ? 4'b1001 :  // 9
    ring_counter[7] ? 4'b1000 :  // 8
    ring_counter[6] ? 4'b0111 :  // 7
    ring_counter[5] ? 4'b0110 :  // 6
    ring_counter[4] ? 4'b0101 :  // 5
    ring_counter[3] ? 4'b0100 :  // 4
    ring_counter[2] ? 4'b0011 :  // 3
    ring_counter[1] ? 4'b0010 :  // 2
                      4'b0001;  // 1

assign q = encoded_out;

always @(posedge clk) begin
    if (reset) begin
        ring_counter <= 10'b0000000001;  // Reset to 1
    end
    else begin
        // Shift left, wrap around from 10 to 1
        ring_counter <= ring_counter[9] ? 10'b0000000001 : {ring_counter[8:0], 1'b0};
    end
end

endmodule