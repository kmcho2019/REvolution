module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each bit
            for (integer i = 0; i < 512; i = i + 1) begin
                // Get neighbors with boundary conditions
                reg left, center, right;
                center = q[i];
                left = (i == 511) ? 1'b0 : q[i+1];
                right = (i == 0) ? 1'b0 : q[i-1];

                // Apply Rule 110
                case ({left, center, right})
                    3'b111: q[i] <= 1'b0;
                    3'b110: q[i] <= 1'b1;
                    3'b101: q[i] <= 1'b1;
                    3'b100: q[i] <= 1'b0;
                    3'b011: q[i] <= 1'b1;
                    3'b010: q[i] <= 1'b1;
                    3'b001: q[i] <= 1'b1;
                    3'b000: q[i] <= 1'b0;
                endcase
            end
        end
    end

endmodule