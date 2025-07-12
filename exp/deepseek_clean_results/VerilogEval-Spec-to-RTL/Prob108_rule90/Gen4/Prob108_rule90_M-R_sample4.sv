module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] state;
    
    // Combinational next state logic
    wire [511:0] next_state;
    
    // Left boundary (left neighbor = 0)
    assign next_state[0] = state[1] ^ 1'b0;
    
    // Middle cells
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : middle_cells
            assign next_state[i] = state[i+1] ^ state[i-1];
        end
    endgenerate
    
    // Right boundary (right neighbor = 0)
    assign next_state[511] = 1'b0 ^ state[510];
    
    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= next_state;
        end
    end
    
    // Output assignment
    assign q = state;

endmodule