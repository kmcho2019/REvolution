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
            // Apply Rule 110 with simplified logic
            q <= {1'b0, q[511:1]} ^ (q | ({q[510:0], 1'b0} & q));
        end
    end

endmodule