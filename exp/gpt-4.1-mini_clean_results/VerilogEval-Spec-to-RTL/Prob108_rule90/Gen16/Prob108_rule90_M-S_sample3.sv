module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state with zero boundary at edges
            for (i = 0; i < 512; i = i + 1) begin
                // left neighbor is 0 if i == 0
                // right neighbor is 0 if i == 511
                next_state[i] <= (i == 0 ? 1'b0 : q[i-1]) ^ (i == 511 ? 1'b0 : q[i+1]);
            end
            q <= next_state;
        end
    end
endmodule