module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [3:0] cnt; // 4-bit counter
reg [7:0] dout_parallel_reg; // register to hold parallel output data
reg dout_valid_reg; // register to hold output validity signal

// assign output signals
assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        cnt <= 4'b0000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin // when input is valid
        if (cnt == 4'b1000) begin // when 8 bits have been received
            cnt <= 4'b0000;
            dout_valid_reg <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial}; // shift input bit into register
            dout_valid_reg <= 1'b0;
        end
    end else begin // when input is not valid
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        if (cnt == 4'b1000) begin
            dout_valid_reg <= 1'b1;
        end else begin
            dout_valid_reg <= 1'b0;
        end
    end
end

endmodule