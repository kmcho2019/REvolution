module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Extended array with boundary conditions (0 on both ends)
wire [513:0] extended_q = {1'b0, q, 1'b0};

// Next state computation
wire [511:0] next_q;
genvar i;
generate
    for (i = 0; i < 512; i = i + 1) begin : rule90
        assign next_q[i] = extended_q[i] ^ extended_q[i+2];  // q[i-1] ^ q[i+1]
    end
endgenerate

// Sequential update
always @(posedge clk) begin
    if (load)
        q <= data;
    else
        q <= next_q;
end

endmodule