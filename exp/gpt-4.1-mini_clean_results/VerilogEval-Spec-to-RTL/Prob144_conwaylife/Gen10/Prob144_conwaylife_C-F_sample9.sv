module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [255:0] data,
    output reg  [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF; // For modulo 16 wrap-around

    reg [255:0] next_q;

    integer r, c, dr, dc;
    reg [3:0] nr, nc;
    reg [3:0] neighbor_count;
    reg current_cell;

    always @* begin
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                neighbor_count = 0;
                // Sum the 8 neighbors with wrap-around using mask
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr) & MASK;
                            nc = (c + dc) & MASK;
                            neighbor_count = neighbor_count + q[{nr, nc}];
                        end
                    end
                end
                current_cell = q[{r, c}];

                // Apply rules:
                // 0-1 neighbors: 0
                // 2 neighbors: no change
                // 3 neighbors: 1
                // 4+ neighbors: 0
                if      (neighbor_count <= 1) next_q[{r,c}] = 1'b0;
                else if (neighbor_count == 2) next_q[{r,c}] = current_cell;
                else if (neighbor_count == 3) next_q[{r,c}] = 1'b1;
                else                           next_q[{r,c}] = 1'b0;
            end
        end
    end

    // Synchronous state update with load
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule