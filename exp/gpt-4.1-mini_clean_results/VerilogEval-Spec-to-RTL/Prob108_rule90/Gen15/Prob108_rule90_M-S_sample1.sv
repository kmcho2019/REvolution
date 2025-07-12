module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] next_state;

    // Apply boundary condition with zero padding: left neighbor of q[0] = 0, right neighbor of q[511] = 0
    assign next_state = (q << 1) ^ (q >> 1);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule