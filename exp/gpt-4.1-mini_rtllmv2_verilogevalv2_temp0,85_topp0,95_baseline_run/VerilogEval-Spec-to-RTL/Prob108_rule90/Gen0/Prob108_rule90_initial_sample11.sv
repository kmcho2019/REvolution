module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    integer i;
    always @(*) begin
        // Calculate next state based on current q
        // q[-1] and q[512] are assumed zero
        for (i = 0; i < 512; i = i + 1) begin
            // left neighbor: q[i-1], zero if i==0
            // right neighbor: q[i+1], zero if i==511
            next_q[i] = ((i == 0   ? 1'b0 : q[i-1]) ^ 
                         (i == 511 ? 1'b0 : q[i+1]));
        end
    end

    always @(posedge clk) begin
        if (load) 
            q <= data;
        else
            q <= next_q;
    end

endmodule