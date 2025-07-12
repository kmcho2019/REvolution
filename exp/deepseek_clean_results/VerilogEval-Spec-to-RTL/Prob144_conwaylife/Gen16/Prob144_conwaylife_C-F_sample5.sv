module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Optimized neighbor position calculations with bitwise masking
                localparam [3:0] row_prev = (i - 1) & 15;
                localparam [3:0] row_next = (i + 1) & 15;
                localparam [3:0] col_prev = (j - 1) & 15;
                localparam [3:0] col_next = (j + 1) & 15;
                
                // Pre-compute all neighbor indices
                localparam [7:0] n0 = row_prev*16 + col_prev;
                localparam [7:0] n1 = row_prev*16 + j;
                localparam [7:0] n2 = row_prev*16 + col_next;
                localparam [7:0] n3 = i*16 + col_prev;
                localparam [7:0] n4 = i*16 + col_next;
                localparam [7:0] n5 = row_next*16 + col_prev;
                localparam [7:0] n6 = row_next*16 + j;
                localparam [7:0] n7 = row_next*16 + col_next;
                
                // Carry-save neighbor counting
                wire [1:0] sum_top = q[n0] + q[n1] + q[n2];
                wire [1:0] sum_mid = q[n3] + q[n4];
                wire [1:0] sum_bot = q[n5] + q[n6] + q[n7];
                
                // Final count with optimized addition
                wire [3:0] neighbor_count = sum_top + sum_mid + sum_bot;
                
                // Direct next state calculation
                assign next_q[idx] = (neighbor_count == 3) || 
                                   ((neighbor_count == 2) && q[idx]);
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
                if (next_q[i] != q[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule