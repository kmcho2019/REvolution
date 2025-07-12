module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Extended array with boundary conditions
wire [513:0] extended_q = {1'b0, q, 1'b0};

// Next state computation
wire [511:0] next_q;
genvar i;
generate
    for (i = 0; i < 512; i = i + 1) begin : rule90
        assign next_q[i] = extended_q[i] ^ extended_q[i+2]; // XOR left and right neighbors
    end
endgenerate

// Sequential update
always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule