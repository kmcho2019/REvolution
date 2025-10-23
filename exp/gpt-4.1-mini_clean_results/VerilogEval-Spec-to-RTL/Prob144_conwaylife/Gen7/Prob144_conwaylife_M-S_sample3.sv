module TopModule(
    input         clk,
    input         load,
    input  [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    reg [255:0] next_q;

    // Function to get the wrapped index using bitwise AND (mod 16)
    function [3:0] wrap_idx(input integer idx);
        wrap_idx = idx[3:0]; // lower 4 bits => modulo 16
    endfunction

    integer r, c;
    reg [3:0] nr, nc;

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                // Calculate neighbors explicitly
                integer count;
                count = 0;

                // neighbors' relative positions
                // Using wrap_idx for toroidal wrap
                nr = wrap_idx(r - 1); nc = wrap_idx(c - 1);
                count = count + q[(nr << 4) + nc];
                nr = wrap_idx(r - 1); nc = wrap_idx(c);
                count = count + q[(nr << 4) + nc];
                nr = wrap_idx(r - 1); nc = wrap_idx(c + 1);
                count = count + q[(nr << 4) + nc];
                nr = wrap_idx(r);     nc = wrap_idx(c - 1);
                count = count + q[(nr << 4) + nc];
                nr = wrap_idx(r);     nc = wrap_idx(c + 1);
                count = count + q[(nr << 4) + nc];
                nr = wrap_idx(r + 1); nc = wrap_idx(c - 1);
                count = count + q[(nr << 4) + nc];
                nr = wrap_idx(r + 1); nc = wrap_idx(c);
                count = count + q[(nr << 4) + nc];
                nr = wrap_idx(r + 1); nc = wrap_idx(c + 1);
                count = count + q[(nr << 4) + nc];

                // Current cell
                reg cell;
                cell = q[(r << 4) + c];

                // Apply rules
                if (count <= 1)
                    next_q[(r << 4) + c] = 1'b0;
                else if (count == 2)
                    next_q[(r << 4) + c] = cell;
                else if (count == 3)
                    next_q[(r << 4) + c] = 1'b1;
                else
                    next_q[(r << 4) + c] = 1'b0;
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