module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [255:0] cell_changed;  // Indicates cells that will change state
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Calculate neighbor positions with optimized wrap-around
                wire [3:0] row_prev = (i-1) & 15;
                wire [3:0] row_next = (i+1) & 15;
                wire [3:0] col_prev = (j-1) & 15;
                wire [3:0] col_next = (j+1) & 15;
                
                // Pre-compute all neighbor indices
                wire [7:0] n0 = row_prev*16 + col_prev; // top-left
                wire [7:0] n1 = row_prev*16 + j;       // top
                wire [7:0] n2 = row_prev*16 + col_next; // top-right
                wire [7:0] n3 = i*16 + col_prev;        // left
                wire [7:0] n4 = i*16 + col_next;        // right
                wire [7:0] n5 = row_next*16 + col_prev; // bottom-left
                wire [7:0] n6 = row_next*16 + j;        // bottom
                wire [7:0] n7 = row_next*16 + col_next; // bottom-right
                
                // Optimized neighbor counting with carry-save structure
                wire [1:0] sum_top = q[n0] + q[n1] + q[n2];
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [1:0] sum_bot = q[n5] + q[n6] + q[n7];
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Next state calculation with stability detection
                wire will_birth = (neighbor_count == 3);
                wire will_survive = (neighbor_count == 2) & q[idx];
                wire will_die = ~(will_birth | will_survive);
                
                assign next_q[idx] = will_birth | will_survive;
                assign cell_changed[idx] = (will_birth & ~q[idx]) | (will_die & q[idx]);
            end
        end
    endgenerate

    // Optimized sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells that will change state
            for (integer i = 0; i < 256; i = i + 1) begin
                if (cell_changed[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule