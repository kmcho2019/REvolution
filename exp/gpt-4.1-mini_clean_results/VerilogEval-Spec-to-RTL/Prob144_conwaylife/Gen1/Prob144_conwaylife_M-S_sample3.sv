module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Grid dimensions
    localparam SIZE = 16;

    // Convert 1D index to row
    function [3:0] row;
        input [7:0] i;
        begin
            row = i / SIZE;
        end
    endfunction

    // Convert 1D index to column
    function [3:0] col;
        input [7:0] i;
        begin
            col = i % SIZE;
        end
    endfunction

    // Modular wrap for 4-bit coordinates
    function [3:0] wrap;
        input integer val;
        begin
            if (val < 0)
                wrap = val + SIZE;
            else if (val >= SIZE)
                wrap = val - SIZE;
            else
                wrap = val[3:0];
        end
    endfunction

    integer i, dr, dc;
    reg [3:0] r, c, nr, nc;
    reg [3:0] count;
    reg current_cell;
    reg [255:0] next_q;

    always @* begin
        next_q = 256'd0;
        for (i = 0; i < 256; i = i + 1) begin
            r = row(i);
            c = col(i);
            count = 0;
            current_cell = q[i];
            // Sum 8 neighbors
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        nr = wrap(r + dr);
                        nc = wrap(c + dc);
                        count = count + q[nr*SIZE + nc];
                    end
                end
            end
            // Apply rules
            if (count == 2)
                next_q[i] = current_cell;
            else if (count == 3)
                next_q[i] = 1'b1;
            else
                next_q[i] = 1'b0;
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule