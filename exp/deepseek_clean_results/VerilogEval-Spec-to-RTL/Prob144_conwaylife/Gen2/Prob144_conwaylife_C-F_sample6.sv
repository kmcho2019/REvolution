module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state logic
    wire [255:0] next_q;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Pre-compute all neighbor positions with toroidal wrapping as constants
                localparam [7:0] n0 = ((i+15)%16)*16 + ((j+15)%16); // top-left
                localparam [7:0] n1 = ((i+15)%16)*16 + j;           // top
                localparam [7:0] n2 = ((i+15)%16)*16 + ((j+1)%16);   // top-right
                localparam [7:0] n3 = i*16 + ((j+15)%16);            // left
                localparam [7:0] n4 = i*16 + ((j+1)%16);            // right
                localparam [7:0] n5 = ((i+1)%16)*16 + ((j+15)%16);   // bottom-left
                localparam [7:0] n6 = ((i+1)%16)*16 + j;            // bottom
                localparam [7:0] n7 = ((i+1)%16)*16 + ((j+1)%16);    // bottom-right
                
                // Count live neighbors using reduction OR for efficiency
                wire [3:0] neighbor_count;
                assign neighbor_count = q[n0] + q[n1] + q[n2] + q[n3] +
                                       q[n4] + q[n5] + q[n6] + q[n7];
                
                // State update rules implemented as priority logic
                assign next_q[idx] = (neighbor_count == 3) ? 1'b1 :
                                    (neighbor_count == 2) ? q[idx] :
                                    1'b0;
            end
        end
    endgenerate

    // Synchronous state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule