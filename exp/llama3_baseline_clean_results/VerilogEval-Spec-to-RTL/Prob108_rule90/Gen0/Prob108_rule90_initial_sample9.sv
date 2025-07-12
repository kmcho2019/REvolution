module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        reg [511:0] next_state;
        next_state[0] <= q[1] ^ q[0];
        next_state[511] <= q[511] ^ q[510];
        for (genvar i = 1; i < 511; i++) begin
            next_state[i] <= q[i-1] ^ q[i+1];
        end
        q <= next_state;
    end
end

endmodule