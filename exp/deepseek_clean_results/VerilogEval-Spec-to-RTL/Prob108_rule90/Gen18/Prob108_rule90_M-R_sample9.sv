module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational Rule 90 logic with boundary handling
    wire [511:0] next_state;
    
    // Edge cases
    assign next_state[0] = 1'b0 ^ q[1];       // Left neighbor is 0
    assign next_state[511] = q[510] ^ 1'b0;    // Right neighbor is 0
    
    // Middle cases
    genvar i;
    for (i = 1; i < 511; i = i + 1) begin: middle_cells
        assign next_state[i] = q[i-1] ^ q[i+1];
    end

    // Synchronous update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule