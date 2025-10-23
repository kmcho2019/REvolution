module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to get cell value with toroidal wrapping
    function automatic get_cell;
        input [7:0] row;  // 0-15
        input [7:0] col;  // 0-15
        begin
            // Apply toroidal wrapping
            row = row % 16;
            col = col % 16;
            get_cell = q[row*16 + col];
        end
    endfunction

    wire [255:0] next_q;
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                // Calculate neighbor count
                reg [3:0] neighbors;
                always @(*) begin
                    neighbors = 
                        get_cell(i-1, j-1) + get_cell(i-1, j) + get_cell(i-1, j+1) +
                        get_cell(i,   j-1)                     + get_cell(i,   j+1) +
                        get_cell(i+1, j-1) + get_cell(i+1, j) + get_cell(i+1, j+1);
                end

                // Apply game rules
                assign next_q[i*16 + j] = 
                    (neighbors == 2) ? q[i*16 + j] :
                    (neighbors == 3) ? 1'b1 :
                    1'b0;
            end
        end
    endgenerate

    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule