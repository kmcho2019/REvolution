module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
wire [WIDTH-1:0] next_q;

// Create extended version of q with boundary conditions
wire [WIDTH:0] q_ext = {1'b0, q, 1'b0};

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        assign next_q[i] = q_ext[i] ^ q_ext[i+2]; // XOR left and right neighbors
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