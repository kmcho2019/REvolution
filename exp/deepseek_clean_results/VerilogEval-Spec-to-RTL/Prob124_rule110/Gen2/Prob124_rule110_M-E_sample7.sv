module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;

    // Generate 512 parallel Rule 110 cells
    genvar j;
    generate
        for (j = 0; j < 512; j = j + 1) begin : rule110_cells
            always @(*) begin
                reg left, center, right;
                center = q[j];
                left = (j == 511) ? q[0] : q[j+1];  // Circular left neighbor
                right = (j == 0) ? q[511] : q[j-1]; // Circular right neighbor

                // Optimized Rule 110 implementation
                case ({left, center, right})
                    3'b000, 3'b100, 3'b111: next_q[j] = 1'b0;
                    default: next_q[j] = 1'b1;
                endcase
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule