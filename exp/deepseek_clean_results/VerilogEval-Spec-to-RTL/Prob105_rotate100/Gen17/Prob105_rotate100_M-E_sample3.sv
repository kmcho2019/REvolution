module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] reg_q;

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin: rotate_units
        always @(posedge clk) begin
            if (load) begin
                reg_q[i] <= data[i];
            end else begin
                case (ena)
                    2'b01: // Right rotate
                        reg_q[i] <= (i == 99) ? reg_q[0] : reg_q[i+1];
                    2'b10: // Left rotate
                        reg_q[i] <= (i == 0) ? reg_q[99] : reg_q[i-1];
                    default: // No rotate
                        reg_q[i] <= reg_q[i];
                endcase
            end
        end
    end
endgenerate

assign q = reg_q;

endmodule