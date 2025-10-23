module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

// Stage 1: Input Buffering and Validity Check
reg din_serial_reg;
reg din_valid_reg;
reg [3:0] cnt;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        din_serial_reg <= 1'b0;
        din_valid_reg <= 1'b0;
        cnt <= 4'b0000;
    end else begin
        din_serial_reg <= din_serial;
        din_valid_reg <= din_valid;
        if (din_valid_reg) begin
            if (cnt == 4'b1000) begin
                cnt <= 4'b0000;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end
end

// Stage 2: Data Shifting and Parallelization
reg [7:0] dout_parallel_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'b00000000;
    end else if (din_valid_reg) begin
        dout_parallel_reg <= {din_serial_reg, dout_parallel_reg[7:1]};
    end
end

// Stage 3: Output Validity Signal Generation
reg dout_valid_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_valid_reg <= 1'b0;
    end else if (cnt == 4'b1000) begin
        dout_valid_reg <= 1'b1;
    end else if (~din_valid_reg) begin
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule