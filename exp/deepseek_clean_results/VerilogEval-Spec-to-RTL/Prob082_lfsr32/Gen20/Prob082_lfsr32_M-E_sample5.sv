module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Parallel XOR network for all taps
wire feedback = q[31] ^ q[22] ^ q[2] ^ q[1];
wire [31:0] next_q;

// Efficient shift with parallel feedback injection
assign next_q = {q[0], q[31:23], 
                q[22] ^ feedback, 
                q[21:3], 
                q[2] ^ feedback, 
                q[1] ^ feedback};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

endmodule