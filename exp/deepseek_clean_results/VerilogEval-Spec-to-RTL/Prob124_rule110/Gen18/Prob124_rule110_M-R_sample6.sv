module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Calculate next state for each cell
    assign next_q[0] = (q[0] ^ (1'b0 & q[1])) | (~1'b0 & q[1]);  // Left boundary = 0
    assign next_q[511] = (q[511] ^ (q[510] & 1'b0)) | (~q[510] & 1'b0);  // Right boundary = 0

    // Middle cells
    genvar i;
    for (i = 1; i < 511; i = i + 1) begin
        assign next_q[i] = (q[i] ^ (q[i+1] & q[i-1])) | (~q[i+1] & q[i-1]);
    end

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule