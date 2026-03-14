module TopModule (
    input  logic         clk,
    input  logic         load,
    input  logic [255:0] data,
    output logic [255:0] q
);
    // Sequential state register with synchronous load
    always_ff @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    // Combinational next‑state logic
    logic [255:0] next_q;
    // Small counter sufficient for up to 8 neighbours
    logic [3:0] cnt;
    integer i, j;
    integer im1, ip1, jm1, jp1;
    integer idx;

    always_comb begin
        for (i = 0; i < 16; i = i + 1) begin
            // row wrap indices
            im1 = (i == 0)   ? 15 : i - 1;
            ip1 = (i == 15)  ? 0  : i + 1;
            for (j = 0; j < 16; j = j + 1) begin
                // column wrap indices
                jm1 = (j == 0)   ? 15 : j - 1;
                jp1 = (j == 15)  ? 0  : j + 1;

                // count live neighbours
                cnt = 0;
                cnt = cnt + q[im1*16 + jm1];
                cnt = cnt + q[im1*16 + j   ];
                cnt = cnt + q[im1*16 + jp1];
                cnt = cnt + q[i   *16 + jm1];
                cnt = cnt + q[i   *16 + jp1];
                cnt = cnt + q[ip1*16 + jm1];
                cnt = cnt + q[ip1*16 + j   ];
                cnt = cnt + q[ip1*16 + jp1];

                idx = i*16 + j; // linear index of current cell
                // Apply Game of Life rules (variant)
                if (cnt == 2) begin
                    next_q[idx] = q[idx];   // unchanged
                end else if (cnt == 3) begin
                    next_q[idx] = 1'b1;     // becomes alive
                end else begin
                    next_q[idx] = 1'b0;     // dies or stays dead
                end
            end
        end
    end
endmodule