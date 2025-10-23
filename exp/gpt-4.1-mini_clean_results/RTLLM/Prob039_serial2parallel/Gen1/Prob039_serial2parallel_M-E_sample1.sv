module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [3:0] cnt;          // Counter for received bits (0 to 7)
    reg [7:0] data_reg;     // Register to hold incoming bits

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt          <= 4'd0;
            data_reg     <= 8'd0;
            dout_parallel<= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default no valid output each cycle
            if (din_valid) begin
                data_reg[7 - cnt] <= din_serial;  // Store bit from MSB to LSB
                if (cnt == 4'd7) begin
                    dout_parallel <= {data_reg[7:1], din_serial}; // Output full 8 bits
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule