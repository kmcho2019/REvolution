module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Boundary bits with neighbors outside are zero
            next_state[0] = q[1] ^ 1'b0;
            next_state[511] = q[510] ^ 1'b0;
            // Compute next_state for middle bits
            for (i = 1; i < 511; i = i + 1) begin
                next_state[i] = q[i-1] ^ q[i+1];
            end
            q <= next_state;
        end
    end

endmodule