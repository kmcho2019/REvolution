module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_state;
    
    // Neighbor counting and state update for all cells
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Compute neighbor indices with bitwise masking
                wire [7:0] n0 = ((i-1)&15)*16 + ((j-1)&15);
                wire [7:0] n1 = ((i-1)&15)*16 + j;
                wire [7:0] n2 = ((i-1)&15)*16 + ((j+1)&15);
                wire [7:0] n3 = i*16 + ((j-1)&15);
                wire [7:0] n4 = i*16 + ((j+1)&15);
                wire [7:0] n5 = ((i+1)&15)*16 + ((j-1)&15);
                wire [7:0] n6 = ((i+1)&15)*16 + j;
                wire [7:0] n7 = ((i+1)&15)*16 + ((j+1)&15);
                
                // 3-level adder tree for neighbor counting
                wire [3:0] count;
                wire [1:0] sum_a = q[n0] + q[n1] + q[n2];
                wire [1:0] sum_b = q[n3] + q[n4] + q[n5];
                wire [1:0] sum_c = q[n6] + q[n7];
                assign count = sum_a + sum_b + sum_c;
                
                // State update as Boolean expression
                assign next_state[i*16+j] = (count == 3) || (count == 2 && q[i*16+j]);
            end
        end
    endgenerate

    // Synchronous update with load mux
    always @(posedge clk) begin
        q <= load ? data : next_state;
    end

endmodule