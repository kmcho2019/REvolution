module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Compute next state of each cell based on Rule 110
wire [511:0] next_state;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        // Handle boundary cases
        wire left, center, right;
        assign left = (i == 0) ? 1'b0 : q[i-1];
        assign center = q[i];
        assign right = (i == 511) ? 1'b0 : q[i+1];

        // Implement Rule 110 table
        assign next_state[i] = (left && center && right) ? 1'b0 :
                              (left && center && ~right) ? 1'b1 :
                              (left && ~center && right) ? 1'b1 :
                              (left && ~center && ~right) ? 1'b0 :
                              (~left && center && right) ? 1'b1 :
                              (~left && center && ~right) ? 1'b1 :
                              (~left && ~center && right) ? 1'b1 :
                              (~left && ~center && ~right) ? 1'b0 : 1'bx;
    end
endgenerate

// Update register on positive edge of clock
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_state;
    end
end

endmodule