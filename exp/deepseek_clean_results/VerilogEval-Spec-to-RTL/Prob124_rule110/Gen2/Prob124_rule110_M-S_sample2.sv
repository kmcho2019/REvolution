module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) q <= data;
        else q <= next_q;
    end

    always @(*) begin
        // Handle all cells in parallel
        for (integer i = 0; i < 512; i = i + 1) begin
            // Get neighbors with boundary conditions (0 for out-of-bounds)
            bit left = (i > 0) ? q[i-1] : 1'b0;
            bit right = (i < 511) ? q[i+1] : 1'b0;
            bit center = q[i];

            // Direct Rule 110 implementation
            case ({left, center, right})
                3'b111: next_q[i] = 1'b0;
                3'b110: next_q[i] = 1'b1;
                3'b101: next_q[i] = 1'b1;
                3'b100: next_q[i] = 1'b0;
                3'b011: next_q[i] = 1'b1;
                3'b010: next_q[i] = 1'b1;
                3'b001: next_q[i] = 1'b1;
                3'b000: next_q[i] = 1'b0;
                default: next_q[i] = 1'b0;
            endcase
        end
    end

endmodule