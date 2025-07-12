module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
wire [WIDTH-1:0] next_q;

// Create extended version of q with boundary conditions (0 on both sides)
// q_ext[513:0] = {1'b0, q, 1'b0} but properly sized
wire [513:0] q_ext = {1'b0, q, 1'b0};

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        // Neighbors are q_ext[i+1] (left) and q_ext[i+3] (right)
        assign next_q[i] = q_ext[i+1] ^ q_ext[i+3];
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