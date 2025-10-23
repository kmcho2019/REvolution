module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;
    end else begin
        if (q[0]) begin
            q <= {1, q[3:1]};
        end else begin
            q <= {q[2:0], 1'b1};
        end
    end
end

endmodule