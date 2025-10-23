module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Compute next state with boundary zeros
    assign next_q[0] = q[1] ^ 1'b0;
    assign next_q[511] = q[510] ^ 1'b0;
    assign next_q[510:1] = q[509:0] ^ q[511:2];

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule