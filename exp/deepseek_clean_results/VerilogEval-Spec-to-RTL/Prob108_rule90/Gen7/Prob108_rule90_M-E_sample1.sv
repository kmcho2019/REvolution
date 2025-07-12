module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;

// Circular boundary implementation
// left neighbor is {q[510:0], q[511]} (left shift with wrap-around)
// right neighbor is {q[0], q[511:1]} (right shift with wrap-around)
assign next_q = {q[510:0], q[511]} ^ {q[0], q[511:1]};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule