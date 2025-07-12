module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Break into 8 segments of 64 bits each
wire [511:0] next_q;
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: segment
        // Calculate left and right shifts within segment
        wire [63:0] segment_q = q[i*64 +: 64];
        wire [63:0] left_shifted = {segment_q[62:0], (i == 7) ? 1'b0 : q[(i+1)*64]};
        wire [63:0] right_shifted = {(i == 0) ? 1'b0 : q[i*64-1], segment_q[63:1]};
        
        assign next_q[i*64 +: 64] = left_shifted ^ right_shifted;
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule