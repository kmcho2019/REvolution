module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Next state logic with pipelining
    reg [255:0] next_q;
    reg [255:0] stage1_q;
    reg [255:0] stage2_q;
    
    // Neighbor counting stage registers
    reg [1023:0] neighbor_counts; // 4 bits per cell (256 cells)
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row_gen
            for (j = 0; j < 16; j = j + 1) begin : col_gen
                localparam idx = i*16 + j;
                
                // Simplified neighbor indexing using bitwise masking
                wire [7:0] n0 = {i[3:0]-4'b0001, j[3:0]-4'b0001}; // top-left
                wire [7:0] n1 = {i[3:0]-4'b0001, j[3:0]};        // top
                wire [7:0] n2 = {i[3:0]-4'b0001, j[3:0]+4'b0001}; // top-right
                wire [7:0] n3 = {i[3:0],        j[3:0]-4'b0001};   // left
                wire [7:0] n4 = {i[3:0],        j[3:0]+4'b0001};   // right
                wire [7:0] n5 = {i[3:0]+4'b0001, j[3:0]-4'b0001};  // bottom-left
                wire [7:0] n6 = {i[3:0]+4'b0001, j[3:0]};          // bottom
                wire [7:0] n7 = {i[3:0]+4'b0001, j[3:0]+4'b0001};  // bottom-right

                // First pipeline stage: neighbor index calculation
                always @(posedge clk) begin
                    if (load) begin
                        stage1_q[idx] <= data[idx];
                    end else begin
                        stage1_q[idx] <= q[idx];
                    end
                end

                // Second pipeline stage: neighbor counting (carry-save structure)
                always @(posedge clk) begin
                    neighbor_counts[idx*4 +: 4] <= 
                        q[n0[7:4]*16 + n0[3:0]] + q[n1[7:4]*16 + n1[3:0]] +
                        q[n2[7:4]*16 + n2[3:0]] + q[n3[7:4]*16 + n3[3:0]] +
                        q[n4[7:4]*16 + n4[3:0]] + q[n5[7:4]*16 + n5[3:0]] +
                        q[n6[7:4]*16 + n6[3:0]] + q[n7[7:4]*16 + n7[3:0]];
                end

                // Third pipeline stage: state update with clock gating
                always @(posedge clk) begin
                    case (neighbor_counts[idx*4 +: 4])
                        3: next_q[idx] <= 1'b1;
                        2: next_q[idx] <= stage1_q[idx]; // No change - minimal switching
                        default: next_q[idx] <= 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    // Final state update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule