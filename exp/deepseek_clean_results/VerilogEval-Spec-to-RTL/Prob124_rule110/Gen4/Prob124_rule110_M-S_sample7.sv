module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    wire [513:0] extended_q = {1'b0, q, 1'b0};
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Rule 110: next = (center OR right) AND NOT (left AND center AND right)
            next_q[i] = (extended_q[i+1] | extended_q[i]) & ~(extended_q[i+2] & extended_q[i+1] & extended_q[i]);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule