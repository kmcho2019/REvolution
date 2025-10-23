module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;

    // Left boundary cell
    assign next_state[0] = 1'b0 ^ q[1];

    // Middle cells
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : middle_cells
            assign next_state[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    // Right boundary cell
    assign next_state[511] = q[510] ^ 1'b0;

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule