module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Byte enable logic
wire [15:0] byte_enable_mask = {
    {8{byteena[1]}},  // Upper byte enable
    {8{byteena[0]}}   // Lower byte enable
};

// Next state logic with byte-wise enable
wire [15:0] next_q = (byte_enable_mask & d) | (~byte_enable_mask & q);

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        q <= next_q;
    end
end

endmodule