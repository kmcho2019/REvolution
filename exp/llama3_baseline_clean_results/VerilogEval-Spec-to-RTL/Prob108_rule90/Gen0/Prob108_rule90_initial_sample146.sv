module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] state;

always @(posedge clk) begin
    if (load) begin
        state <= data;
    end else begin
        reg [511:0] next_state;
        next_state[0] <= state[0] ^ state[1];
        next_state[511] <= state[510] ^ state[511];
        for (int i = 1; i < 511; i++) begin
            next_state[i] <= state[i-1] ^ state[i+1];
        end
        state <= next_state;
    end
end

assign q = state;

endmodule