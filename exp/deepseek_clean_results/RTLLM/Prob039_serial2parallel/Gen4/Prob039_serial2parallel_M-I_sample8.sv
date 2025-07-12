module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;          // 3-bit counter (0-7)
    reg [7:0] data_reg;     // Combined shift/parallel register
    wire cnt_done = (cnt == 3'd7);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            data_reg <= 8'b0;
            dout_valid <= 1'b0;
        end else if (din_valid) begin
            // Shift in new data only when valid
            data_reg <= {data_reg[6:0], din_serial};
            
            // Update counter and valid signals
            if (cnt_done) begin
                cnt <= 3'b0;
                dout_valid <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
                dout_valid <= 1'b0;
            end
        end else begin
            dout_valid <= 1'b0;
        end
    end

    // Parallel output is always the current register value
    assign dout_parallel = data_reg;

endmodule