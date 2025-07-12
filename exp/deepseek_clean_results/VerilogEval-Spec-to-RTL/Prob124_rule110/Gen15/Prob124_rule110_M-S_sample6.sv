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
            // Update each cell according to Rule 110
            for (integer i = 0; i < 512; i = i + 1) begin
                reg left, right;
                // Handle boundary conditions
                left = (i == 511) ? 1'b0 : q[i+1];
                right = (i == 0) ? 1'b0 : q[i-1];
                
                // Direct implementation of Rule 110 truth table
                case ({left, q[i], right})
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