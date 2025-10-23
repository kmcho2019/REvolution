module TopModule (
    input clk,
    input reset,
    input enable,    // Added for clock gating
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else if (enable) begin
        q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
    end
end

endmodule