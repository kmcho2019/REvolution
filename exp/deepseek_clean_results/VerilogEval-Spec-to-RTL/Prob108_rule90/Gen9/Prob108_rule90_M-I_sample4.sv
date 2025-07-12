module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] current_state;
    wire [511:0] next_state;

    // Generate next state for all cells in parallel
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            // Left neighbor is 0 for first cell, current_state[i-1] otherwise
            wire left = (i == 0) ? 1'b0 : current_state[i-1];
            // Right neighbor is 0 for last cell, current_state[i+1] otherwise
            wire right = (i == 511) ? 1'b0 : current_state[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            q <= data;
        end else begin
            current_state <= next_state;
            q <= next_state;
        end
    end

endmodule