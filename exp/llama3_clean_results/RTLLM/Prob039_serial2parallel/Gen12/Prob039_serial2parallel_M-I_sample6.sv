module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // Using 3-bit counter for 8 cycles
reg [7:0] dout_parallel_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial}; // Simplified concatenation
        cnt <= cnt + 1'b1;
        if (cnt == 3'b111) begin // Check for 8th cycle
            dout_valid <= 1'b1;
            cnt <= 3'b000; // Reset counter
        end else begin
            dout_valid <= 1'b0;
        end
    end else begin
        // Reduce unnecessary switching by not updating registers when din_valid is 0
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        dout_valid <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg; // Continuous assignment for output

endmodule