module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 1; // Initialize q to 1
    end else begin
        // Calculate the next state
        q <= {q[4] ^ q[0], q[3] ^ q[0], q[2], q[1], q[0]};
    end
end

endmodule