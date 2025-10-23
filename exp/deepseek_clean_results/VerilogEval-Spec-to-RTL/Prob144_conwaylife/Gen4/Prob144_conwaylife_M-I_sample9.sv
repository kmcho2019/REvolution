module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Registered neighbor counts and next state
    reg [3:0] neighbor_count [0:255];
    reg [255:0] next_q;
    reg [255:0] q_ff;

    // Row buffers for neighbor access
    reg [15:0] row_buf [0:2];  // Previous, current, next rows

    // Clock gating signals
    wire [255:0] cell_update_en;

    // Pipelined neighbor counting
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_ff <= data;
        end else begin
            q <= next_q;
            q_ff <= q;
        end
    end

    // Generate logic for each row
    genvar row;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            integer col;
            always @(*) begin
                // Circular row buffering
                row_buf[0] = (row == 0) ? q_ff[255:240] : q_ff[row*16-1 -:16];
                row_buf[1] = q_ff[row*16 +:16];
                row_buf[2] = (row == 15) ? q_ff[15:0] : q_ff[(row+1)*16 +:16];

                for (col = 0; col < 16; col = col + 1) begin
                    // Neighbor counting using Gray code
                    reg [3:0] count_stage1, count_stage2;
                    count_stage1 = {2'b0, row_buf[0][(col-1)%16]} + {2'b0, row_buf[0][col]} + 
                                  {2'b0, row_buf[0][(col+1)%16]} + {2'b0, row_buf[1][(col-1)%16]};
                    count_stage2 = {2'b0, row_buf[1][(col+1)%16]} + {2'b0, row_buf[2][(col-1)%16]} + 
                                  {2'b0, row_buf[2][col]} + {2'b0, row_buf[2][(col+1)%16]};
                    neighbor_count[row*16+col] = count_stage1 + count_stage2;

                    // Clock gating - only update if neighbor count ≠ 2
                    cell_update_en[row*16+col] = (neighbor_count[row*16+col] != 3'd2);

                    // LUT-based state transition
                    next_q[row*16+col] = (neighbor_count[row*16+col] == 3) ? 1'b1 :
                                        ((neighbor_count[row*16+col] == 2) ? q_ff[row*16+col] : 1'b0);
                end
            end
        end
    endgenerate

    // Clock-gated update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer i = 0; i < 256; i = i + 1) begin
                if (cell_update_en[i]) begin
                    q[i] <= next_q[i];
                end
            end
        end
    end

endmodule