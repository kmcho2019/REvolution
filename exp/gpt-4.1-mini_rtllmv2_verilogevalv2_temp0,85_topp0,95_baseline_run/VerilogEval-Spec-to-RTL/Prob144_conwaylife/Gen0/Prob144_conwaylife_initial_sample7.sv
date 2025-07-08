module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // localparam for size
    localparam N = 16;

    // Convert q and data to 2D for easier indexing
    wire [N-1:0] current_state [N-1:0];
    wire [N-1:0] next_state [N-1:0];

    genvar r,c;
    generate
        for (r=0; r<N; r=r+1) begin: row_unpack
            for (c=0; c<N; c=c+1) begin: col_unpack
                assign current_state[r][c] = q[r*16 + c];
            end
        end
    endgenerate

    // Compute neighbors count for each cell with wrap-around
    wire [3:0] neighbor_count [N-1:0][N-1:0]; // 4 bits to count up to 8

    generate
    for (r=0; r<N; r=r+1) begin: row_loop
        for (c=0; c<N; c=c+1) begin: col_loop
            // Calculate neighbors indices with wrap-around
            // neighbors: 8 cells around (r,c)
            // rows: r-1, r, r+1 modulo N
            // cols: c-1, c, c+1 modulo N
            // exclude (r,c) itself
            // indices modulo N:
            localparam integer r_up = (r + N - 1) % N;
            localparam integer r_down = (r + 1) % N;
            localparam integer c_left = (c + N - 1) % N;
            localparam integer c_right = (c + 1) % N;

            wire [7:0] neighbors_bits;
            assign neighbors_bits[0] = current_state[r_up][c_left];
            assign neighbors_bits[1] = current_state[r_up][c];
            assign neighbors_bits[2] = current_state[r_up][c_right];
            assign neighbors_bits[3] = current_state[r][c_left];
            assign neighbors_bits[4] = current_state[r][c_right];
            assign neighbors_bits[5] = current_state[r_down][c_left];
            assign neighbors_bits[6] = current_state[r_down][c];
            assign neighbors_bits[7] = current_state[r_down][c_right];

            // Sum the 8 neighbors bits
            assign neighbor_count[r][c] =
                neighbors_bits[0] + neighbors_bits[1] + neighbors_bits[2] +
                neighbors_bits[3] + neighbors_bits[4] + neighbors_bits[5] +
                neighbors_bits[6] + neighbors_bits[7];

            // Determine next state according to rules:
            // 0-1 neighbor: 0
            // 2 neighbors: same as current
            // 3 neighbors: 1
            // 4+ neighbors: 0
            assign next_state[r][c] =
                (neighbor_count[r][c] == 4'd2) ? current_state[r][c] :
                (neighbor_count[r][c] == 4'd3) ? 1'b1 : 1'b0;

        end
    end
    endgenerate

    // Pack next_state into a 256-bit vector
    wire [255:0] next_state_vec;
    generate
        for (r=0; r<N; r=r+1) begin: pack_row
            for (c=0; c<N; c=c+1) begin: pack_col
                assign next_state_vec[r*16 + c] = next_state[r][c];
            end
        end
    endgenerate

    // Sequential logic: on posedge clk, if load load data else update to next_state_vec
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state_vec;
    end

endmodule