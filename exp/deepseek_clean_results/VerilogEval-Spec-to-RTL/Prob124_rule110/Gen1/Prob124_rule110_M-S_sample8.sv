module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        // Apply Rule 110 to all cells including boundaries
        next_q = ({1'b0, q[511:1]} & q) | (~q & ({1'b0, q[511:1]} | q[510:0])) | (q & ~{q[510:0], 1'b0});
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule