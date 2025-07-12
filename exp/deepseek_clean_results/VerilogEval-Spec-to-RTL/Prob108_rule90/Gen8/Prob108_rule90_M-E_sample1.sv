module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Circular buffer implementation
    reg [511:0] current_state;
    wire [511:0] next_state;

    // Generate next state for all cells in parallel
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            // Circular boundary handling:
            // left neighbor is cell i-1 (511 when i=0)
            // right neighbor is cell i+1 (0 when i=511)
            wire left = (i == 0) ? current_state[511] : current_state[i-1];
            wire right = (i == 511) ? current_state[0] : current_state[i+1];
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