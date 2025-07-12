module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Boundaries assumed zero
    assign left_neighbors  = {q[510:0], 1'b0};
    assign right_neighbors = {1'b0, q[511:1]};

    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule