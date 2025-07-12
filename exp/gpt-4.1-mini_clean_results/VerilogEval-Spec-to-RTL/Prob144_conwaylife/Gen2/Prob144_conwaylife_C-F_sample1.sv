module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Function to compute wrap-around index mod 16
    function [3:0] wrap;
        input integer idx;
        begin
            if (idx < 0)
                wrap = idx + N;
            else if (idx >= N)
                wrap = idx - N;
            else
                wrap = idx[3:0];
        end
    endfunction

    wire [255:0] next_q;

    genvar idx;
    generate
        for (idx = 0; idx < 256; idx = idx + 1) begin : cell_logic
            // Convert idx to row and col
            localparam integer row = idx / N;
            localparam integer col = idx % N;

            // Compute neighbors with wrap-around indices
            wire n0 = q[wrap(row-1)*N + wrap(col-1)];
            wire n1 = q[wrap(row-1)*N + wrap(col)];
            wire n2 = q[wrap(row-1)*N + wrap(col+1)];
            wire n3 = q[wrap(row)*N   + wrap(col-1)];
            wire n4 = q[wrap(row)*N   + wrap(col+1)];
            wire n5 = q[wrap(row+1)*N + wrap(col-1)];
            wire n6 = q[wrap(row+1)*N + wrap(col)];
            wire n7 = q[wrap(row+1)*N + wrap(col+1)];

            wire [3:0] neighbor_count = n0 + n1 + n2 + n3 + n4 + n5 + n6 + n7;

            wire current_cell = q[idx];

            // Apply rules:
            // 0 or 1 neighbors -> 0
            // 2 neighbors -> current cell state
            // 3 neighbors -> 1
            // 4+ neighbors -> 0
            wire next_cell = (neighbor_count == 2) ? current_cell :
                             (neighbor_count == 3) ? 1'b1 : 1'b0;

            assign next_q[idx] = next_cell;
        end
    endgenerate

    // Sequential logic to update state or load initial data
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule