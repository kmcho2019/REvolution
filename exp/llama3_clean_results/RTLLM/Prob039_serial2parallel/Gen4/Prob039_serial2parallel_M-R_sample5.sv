module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg dout_valid_reg;
reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (din_valid) begin
        if (cnt == 3'b111) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'b00000000;
    end else if (din_valid) begin
        if (cnt == 3'b000) begin
            dout_parallel_reg <= {din_serial, 7'b0000000};
        end else if (cnt == 3'b001) begin
            dout_parallel_reg <= {dout_parallel_reg[7:1], din_serial};
        end else if (cnt == 3'b010) begin
            dout_parallel_reg <= {dout_parallel_reg[7:2], din_serial, 1'b0};
        end else if (cnt == 3'b011) begin
            dout_parallel_reg <= {dout_parallel_reg[7:3], din_serial, 2'b00};
        end else if (cnt == 3'b100) begin
            dout_parallel_reg <= {dout_parallel_reg[7:4], din_serial, 3'b000};
        end else if (cnt == 3'b101) begin
            dout_parallel_reg <= {dout_parallel_reg[7:5], din_serial, 4'b0000};
        end else if (cnt == 3'b110) begin
            dout_parallel_reg <= {dout_parallel_reg[7:6], din_serial, 5'b00000};
        end else if (cnt == 3'b111) begin
            dout_parallel_reg <= {dout_parallel_reg[7:7], din_serial, 6'b000000};
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_valid_reg <= 1'b0;
    end else if (din_valid && cnt == 3'b111) begin
        dout_valid_reg <= 1'b1;
    end else begin
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule