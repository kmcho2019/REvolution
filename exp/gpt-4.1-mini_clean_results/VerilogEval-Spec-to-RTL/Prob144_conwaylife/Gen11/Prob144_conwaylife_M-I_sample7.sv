module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Grid parameters
    localparam SIZE = 16;
    localparam MASK = 4'hF; // for modulo 16 wrapping

    // Row pointer for pipeline (which row is being updated)
    reg [3:0] row_ptr;

    // Registers to hold neighbor counts for 16 cells in a row
    reg [3:0] neighbor_count [0:SIZE-1];

    integer c, ni, nj;
    reg [3:0] nr, nc;
    reg current_cell_state;

    // Temporary next row state register
    reg [SIZE-1:0] next_row_state;

    // Helper function to get q bit at row,col
    function bit get_cell;
        input [3:0] r, c;
        begin
            // q is organized by rows, each 16 bits: q[15:0] row 0, q[31:16] row1, etc.
            get_cell = q[{r, c}];
        end
    endfunction

    // Combinational block to compute neighbor counts for the current row_ptr
    always @* begin
        // For each column in the current row
        for (c = 0; c < SIZE; c = c + 1) begin
            integer cnt;
            cnt = 0;

            // For each neighbor offset (ni,nj)
            for (ni = -1; ni <= 1; ni = ni + 1) begin
                for (nj = -1; nj <= 1; nj = nj + 1) begin
                    if (!(ni == 0 && nj == 0)) begin
                        nr = (row_ptr + ni) & MASK;
                        nc = (c + nj) & MASK;
                        cnt = cnt + q[{nr, nc}];
                    end
                end
            end

            neighbor_count[c] = cnt[3:0];
        end
    end

    // Combinational block to compute next row state based on neighbor counts and current states
    always @* begin
        for (c = 0; c < SIZE; c = c + 1) begin
            current_cell_state = q[{row_ptr, c}];
            case (neighbor_count[c])
                4'd2: next_row_state[c] = current_cell_state;
                4'd3: next_row_state[c] = 1'b1;
                default: next_row_state[c] = 1'b0;
            endcase
        end
    end

    // Sequential logic: load and update
    always @(posedge clk) begin
        if (load) begin
            // Load entire grid state and reset row_ptr
            q <= data;
            row_ptr <= 0;
        end else begin
            // Update the current row in q with next_row_state
            // First, create a mask to clear the bits of the current row
            // Then set bits of next_row_state in q for the current row
            integer bit_index;
            for (bit_index = 0; bit_index < SIZE; bit_index = bit_index + 1) begin
                q[{row_ptr, bit_index}] <= next_row_state[bit_index];
            end
            // Increment row_ptr modulo SIZE
            row_ptr <= (row_ptr + 1) & MASK;
        end
    end

endmodule