module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;
reg [31:0] yout_r;
reg done_r;
reg [15:0] areg;
reg [15:0] breg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        areg <= 16'd0;
        breg <= 16'd0;
    end else begin
        case (i)
            5'd0: begin
                if (start) begin
                    areg <= ain;
                    breg <= bin;
                    i <= i + 1'b1;
                end
            end
            5'd1: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + {16'd0, breg};
                end
                i <= i + 1'b1;
            end
            5'd2: begin
                if (areg[1] == 1'b1) begin
                    yout_r <= yout_r + {15'd0, breg, 1'd0};
                end
                i <= i + 1'b1;
            end
            5'd3: begin
                if (areg[2] == 1'b1) begin
                    yout_r <= yout_r + {14'd0, breg, 2'd0};
                end
                i <= i + 1'b1;
            end
            5'd4: begin
                if (areg[3] == 1'b1) begin
                    yout_r <= yout_r + {13'd0, breg, 3'd0};
                end
                i <= i + 1'b1;
            end
            5'd5: begin
                if (areg[4] == 1'b1) begin
                    yout_r <= yout_r + {12'd0, breg, 4'd0};
                end
                i <= i + 1'b1;
            end
            5'd6: begin
                if (areg[5] == 1'b1) begin
                    yout_r <= yout_r + {11'd0, breg, 5'd0};
                end
                i <= i + 1'b1;
            end
            5'd7: begin
                if (areg[6] == 1'b1) begin
                    yout_r <= yout_r + {10'd0, breg, 6'd0};
                end
                i <= i + 1'b1;
            end
            5'd8: begin
                if (areg[7] == 1'b1) begin
                    yout_r <= yout_r + {9'd0, breg, 7'd0};
                end
                i <= i + 1'b1;
            end
            5'd9: begin
                if (areg[8] == 1'b1) begin
                    yout_r <= yout_r + {8'd0, breg, 8'd0};
                end
                i <= i + 1'b1;
            end
            5'd10: begin
                if (areg[9] == 1'b1) begin
                    yout_r <= yout_r + {7'd0, breg, 9'd0};
                end
                i <= i + 1'b1;
            end
            5'd11: begin
                if (areg[10] == 1'b1) begin
                    yout_r <= yout_r + {6'd0, breg, 10'd0};
                end
                i <= i + 1'b1;
            end
            5'd12: begin
                if (areg[11] == 1'b1) begin
                    yout_r <= yout_r + {5'd0, breg, 11'd0};
                end
                i <= i + 1'b1;
            end
            5'd13: begin
                if (areg[12] == 1'b1) begin
                    yout_r <= yout_r + {4'd0, breg, 12'd0};
                end
                i <= i + 1'b1;
            end
            5'd14: begin
                if (areg[13] == 1'b1) begin
                    yout_r <= yout_r + {3'd0, breg, 13'd0};
                end
                i <= i + 1'b1;
            end
            5'd15: begin
                if (areg[14] == 1'b1) begin
                    yout_r <= yout_r + {2'd0, breg, 14'd0};
                end
                i <= i + 1'b1;
            end
            5'd16: begin
                if (areg[15] == 1'b1) begin
                    yout_r <= yout_r + {1'd0, breg, 15'd0};
                end
                done_r <= 1'b1;
                i <= i + 1'b1;
            end
            default: begin
                done_r <= 1'b0;
                i <= 5'd0;
            end
        endcase
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule