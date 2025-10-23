module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Left neighbor (q[i+1]) with boundary condition (0 when i == 511)
            // Right neighbor (q[i-1]) with boundary condition (0 when i == 0)
            q <= {1'b0, q[511:1]} & q | 
                 q & {q[510:0], 1'b0} | 
                 ~q & {q[510:0], 1'b0} & {1'b0, q[511:1]};
        end
    end

endmodule