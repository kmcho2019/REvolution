module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] gray_count;
wire [3:0] next_gray;
wire counter_enable;

// Binary to Gray conversion
assign q = {gray_count[3], 
            gray_count[3] ^ gray_count[2],
            gray_count[2] ^ gray_count[1],
            gray_count[1] ^ gray_count[0]};

// Gray code increment logic
assign next_gray = (gray_count == 4'b1000) ? 4'b0000 : 
                  {gray_count[3] ^ (&gray_count[2:0]),
                   gray_count[2] ^ (&gray_count[1:0]),
                   gray_count[1] ^ gray_count[0],
                   ~gray_count[0]};

// Enable only when not at max count
assign counter_enable = (gray_count != 4'b1000);

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'b0000;
    end
    else if (counter_enable) begin
        gray_count <= next_gray;
    end
end

endmodule