module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Wrap function using bitwise AND to ensure 0-15 range (mod 16)
    function automatic [3:0] wrap16;
        input integer val;
        begin
            wrap16 = val & 4'hF;
        end
    endfunction

    integer r, c;
    integer ru, rd, cl, cr;
    integer neighbors;
    reg curr_cell;
    reg [255:0] next_state;

    always @(*) begin
        for (r = 0; r < HEIGHT; r = r + 1) begin
            ru = wrap16(r - 1);  // row above with wrap
            rd = wrap16(r + 1);  // row below with wrap
            for (c = 0; c < WIDTH; c = c + 1) begin
                cl = wrap16(c - 1);  // col left with wrap
                cr = wrap16(c + 1);  // col right with wrap

                neighbors = 
                    q[ru*WIDTH + cl] + q[ru*WIDTH + c] + q[ru*WIDTH + cr] +
                    q[r*WIDTH + cl]                + q[r*WIDTH + cr] +
                    q[rd*WIDTH + cl] + q[rd*WIDTH + c] + q[rd*WIDTH + cr];

                curr_cell = q[r*WIDTH + c];

                // Game of Life rules with toroidal neighbors count:
                // 0-1 neighbors => cell dies (0)
                // 2 neighbors => cell stays same
                // 3 neighbors => cell lives (1)
                // 4+ neighbors => cell dies (0)
                if (neighbors <= 1)
                    next_state[r*WIDTH + c] = 1'b0;
                else if (neighbors == 2)
                    next_state[r*WIDTH + c] = curr_cell;
                else if (neighbors == 3)
                    next_state[r*WIDTH + c] = 1'b1;
                else
                    next_state[r*WIDTH + c] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule