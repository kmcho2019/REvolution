module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] stage1 [255:0];
    reg [3:0] neighbor_count [255:0];
    reg [255:0] change_detect;

    // Generate logic for each cell
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_loop
            // Calculate neighbor indices with simplified wrap-around
            wire [7:0] neighbors;
            assign neighbors[0] = q_ff[((i/16 + 15) % 16)*16 + ((i%16 + 15) % 16)]; // NW
            assign neighbors[1] = q_ff[((i/16 + 15) % 16)*16 + (i%16)];             // N
            assign neighbors[2] = q_ff[((i/16 + 15) % 16)*16 + ((i%16 + 1) % 16)];  // NE
            assign neighbors[3] = q_ff[(i/16)*16 + ((i%16 + 15) % 16)];             // W
            assign neighbors[4] = q_ff[(i/16)*16 + ((i%16 + 1) % 16)];              // E
            assign neighbors[5] = q_ff[((i/16 + 1) % 16)*16 + ((i%16 + 15) % 16)];  // SW
            assign neighbors[6] = q_ff[((i/16 + 1) % 16)*16 + (i%16)];              // S
            assign neighbors[7] = q_ff[((i/16 + 1) % 16)*16 + ((i%16 + 1) % 16)];   // SE

            // Pipeline stage 1: Calculate partial sums
            always @(posedge clk) begin
                stage1[i] <= neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3];
            end

            // Pipeline stage 2: Complete neighbor count
            always @(posedge clk) begin
                neighbor_count[i] <= stage1[i] + neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
            end

            // Change detection and clock gating
            always @(*) begin
                case (neighbor_count[i])
                    0, 1: change_detect[i] = (q_ff[i] != 0);
                    2: change_detect[i] = 0;
                    3: change_detect[i] = (q_ff[i] != 1);
                    default: change_detect[i] = (q_ff[i] != 0);
                endcase
            end

            // Clock-gated update
            always @(posedge clk) begin
                if (load) begin
                    q_ff[i] <= data[i];
                end else if (change_detect[i]) begin
                    case (neighbor_count[i])
                        0, 1: q_ff[i] <= 1'b0;
                        2: q_ff[i] <= q_ff[i];
                        3: q_ff[i] <= 1'b1;
                        default: q_ff[i] <= 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    // Output assignment
    always @(*) begin
        q = q_ff;
    end

endmodule