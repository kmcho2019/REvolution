module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [255:0] data,
    output reg  [255:0] q
);
    localparam N = 16;

    // Function to compute modular wrap-around for indices [0..15]
    function [3:0] wrap_index;
        input integer idx;
        begin
            wrap_index = idx[3:0]; // Since idx can be negative or >15, rely on 4-bit truncation + manual fix
            if (idx < 0)
                wrap_index = idx + N;
            else if (idx >= N)
                wrap_index = idx - N;
        end
    endfunction

    // Extract the bit at a specific row and column from current q
    function bit get_cell;
        input [255:0] state;
        input integer row;
        input integer col;
        begin
            get_cell = state[wrap_index(row)*N + wrap_index(col)];
        end
    endfunction

    // Compute neighbor count for a given cell position in current state
    function [3:0] count_neighbors;
        input [255:0] state;
        input integer row;
        input integer col;
        integer dr, dc;
        integer rr, cc;
        reg [3:0] sum;
        begin
            sum = 0;
            for (dr = -1; dr <= 1; dr = dr + 1) begin
                for (dc = -1; dc <= 1; dc = dc + 1) begin
                    if (!(dr == 0 && dc == 0)) begin
                        rr = row + dr;
                        cc = col + dc;
                        sum = sum + get_cell(state, rr, cc);
                    end
                end
            end
            count_neighbors = sum;
        end
    endfunction

    // Wire vector for next state bits
    wire [255:0] next_q_wires;

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_next_state
            localparam integer r = i / N;
            localparam integer c = i % N;

            wire cell_curr = q[i];
            wire [3:0] neighbors = count_neighbors(q, r, c);

            // Assign next cell state based on rules
            assign next_q_wires[i] =
                (neighbors <= 1) ? 1'b0 :
                (neighbors == 2) ? cell_curr :
                (neighbors == 3) ? 1'b1 :
                1'b0;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_wires;
    end

endmodule