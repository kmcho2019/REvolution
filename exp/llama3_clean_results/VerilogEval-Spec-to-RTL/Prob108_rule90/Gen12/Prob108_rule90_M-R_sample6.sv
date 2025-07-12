module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, right;
            left = (i == 0) ? 0 : q[i - 1];
            right = (i == 511) ? 0 : q[i + 1];
            next_state[i] = left ^ right;
        end
        q <= next_state;
    end
end

endmodule