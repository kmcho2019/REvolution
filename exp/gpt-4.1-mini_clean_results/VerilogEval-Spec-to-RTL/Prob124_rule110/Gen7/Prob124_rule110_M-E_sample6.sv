module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Internal register holds extended state: zero-padded on both ends
    reg [513:0] extended_state;

    // Combinational next extended_state calculation
    wire [511:0] left_neighbors  = extended_state[513:2];   // bits [513 down to 2]
    wire [511:0] centers         = extended_state[512:1];   // bits [512 down to 1]
    wire [511:0] right_neighbors = extended_state[511:0];   // bits [511 down to 0]

    wire [511:0] next_cells;

    // Rule 110 logic vectorized:
    // next = (~left & center) | (center ^ right)
    assign next_cells = (~left_neighbors & centers) | (centers ^ right_neighbors);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Pad zeros on boundaries for extended_state
            extended_state <= {1'b0, data, 1'b0};
        end else begin
            q <= next_cells;
            extended_state <= {1'b0, next_cells, 1'b0};
        end
    end

endmodule