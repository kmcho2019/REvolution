module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = SIZE - 1;  // 15 for wrap-around

    reg [255:0] next_q;

    integer r, c;
    reg [3:0] count;

    // Compute next_q combinationally
    always @* begin
        next_q = 256'b0;
        for (r = 0; r < SIZE; r = r + 1) begin
            // Precompute wrapped row indices for neighbors
            // Use bitwise AND to wrap indices mod 16
            int r_up = (r - 1) & MASK;
            int r_down = (r + 1) & MASK;
            int r_mid = r & MASK;

            for (c = 0; c < SIZE; c = c + 1) begin
                int c_left = (c - 1) & MASK;
                int c_right = (c + 1) & MASK;
                int c_mid = c & MASK;

                // Sum neighbors directly by indexing 8 neighbors explicitly
                count =  q[r_up*SIZE + c_left] + q[r_up*SIZE + c_mid] + q[r_up*SIZE + c_right]
                       + q[r_mid*SIZE + c_left]                 + q[r_mid*SIZE + c_right]
                       + q[r_down*SIZE + c_left] + q[r_down*SIZE + c_mid] + q[r_down*SIZE + c_right];

                // Apply Conway's rules:
                // 0-1 neighbors => 0
                // 2 neighbors => same state
                // 3 neighbors => 1
                // 4+ neighbors => 0
                if (count == 3)
                    next_q[r*SIZE + c] = 1'b1;
                else if (count == 2)
                    next_q[r*SIZE + c] = q[r*SIZE + c];
                else
                    next_q[r*SIZE + c] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule