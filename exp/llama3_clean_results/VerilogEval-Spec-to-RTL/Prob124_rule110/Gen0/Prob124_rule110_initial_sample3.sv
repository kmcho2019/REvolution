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
            for (int i = 0; i < 512; i++) begin
                reg left, center, right;
                case (i)
                    0: begin
                        left = 0;
                        center = q[i];
                        right = q[i + 1];
                    end
                    511: begin
                        left = q[i - 1];
                        center = q[i];
                        right = 0;
                    end
                    default: begin
                        left = q[i - 1];
                        center = q[i];
                        right = q[i + 1];
                    end
                endcase
                case ({left, center, right})
                    3'b111: q[i] <= 0;
                    3'b110: q[i] <= 1;
                    3'b101: q[i] <= 1;
                    3'b100: q[i] <= 0;
                    3'b011: q[i] <= 1;
                    3'b010: q[i] <= 1;
                    3'b001: q[i] <= 1;
                    3'b000: q[i] <= 0;
                endcase
            end
        end
    end

endmodule