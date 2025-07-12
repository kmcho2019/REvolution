module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_state;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Neighbor indices with wrap-around using bitwise masking
                wire [7:0] neighbors [7:0];
                assign neighbors[0] = ((i-1)&15)*16 + ((j-1)&15);  // NW
                assign neighbors[1] = ((i-1)&15)*16 + j;            // N
                assign neighbors[2] = ((i-1)&15)*16 + ((j+1)&15);  // NE
                assign neighbors[3] = i*16 + ((j-1)&15);            // W
                assign neighbors[4] = i*16 + ((j+1)&15);            // E
                assign neighbors[5] = ((i+1)&15)*16 + ((j-1)&15);   // SW
                assign neighbors[6] = ((i+1)&15)*16 + j;           // S
                assign neighbors[7] = ((i+1)&15)*16 + ((j+1)&15);   // SE
                
                // Balanced adder tree for neighbor counting
                wire [3:0] count;
                wire [1:0] sum_a = q[neighbors[0]] + q[neighbors[1]] + q[neighbors[2]];
                wire [1:0] sum_b = q[neighbors[3]] + q[neighbors[4]] + q[neighbors[5]];
                wire [1:0] sum_c = q[neighbors[6]] + q[neighbors[7]];
                assign count = sum_a + sum_b + sum_c;
                
                // Optimized state update logic
                always @(*) begin
                    case (count)
                        0, 1, 4, 5, 6, 7, 8: next_state[i*16+j] = 1'b0;
                        2: next_state[i*16+j] = q[i*16+j];
                        3: next_state[i*16+j] = 1'b1;
                        default: next_state[i*16+j] = 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    // Synchronous update with output mux
    always @(posedge clk) begin
        q <= load ? data : next_state;
    end

endmodule