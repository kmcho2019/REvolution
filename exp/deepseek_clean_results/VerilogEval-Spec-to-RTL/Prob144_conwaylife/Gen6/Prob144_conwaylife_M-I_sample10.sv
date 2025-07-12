module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state logic
    wire [255:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_logic
            // Pre-compute neighbor indices for each cell (constant for 16x16 grid)
            localparam [7:0] n0 = ((i/16+15)%16)*16 + ((i%16+15)%16);
            localparam [7:0] n1 = ((i/16+15)%16)*16 + (i%16);
            localparam [7:0] n2 = ((i/16+15)%16)*16 + ((i%16+1)%16);
            localparam [7:0] n3 = (i/16)*16 + ((i%16+15)%16);
            localparam [7:0] n4 = (i/16)*16 + ((i%16+1)%16);
            localparam [7:0] n5 = ((i/16+1)%16)*16 + ((i%16+15)%16);
            localparam [7:0] n6 = ((i/16+1)%16)*16 + (i%16);
            localparam [7:0] n7 = ((i/16+1)%16)*16 + ((i%16+1)%16);
            
            // Count live neighbors using carry-save adder structure
            wire [1:0] sum_stage1 = q[n0] + q[n1] + q[n2];
            wire [1:0] sum_stage2 = q[n3] + q[n4] + q[n5];
            wire [1:0] sum_stage3 = q[n6] + q[n7];
            wire [3:0] neighbor_count = sum_stage1 + sum_stage2 + sum_stage3;
            
            // Apply game rules
            assign next_q[i] = (neighbor_count == 3) ? 1'b1 :
                             (neighbor_count == 2) ? q[i] :
                             1'b0;
        end
    endgenerate

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule