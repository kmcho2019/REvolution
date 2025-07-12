module serial2parallel (
    input            clk,
    input            rst_n,        // Active low synchronous reset
    input            din_serial,   // Serial input bit
    input            din_valid,    // Input data valid
    output reg [7:0] dout_parallel,// 8-bit parallel output
    output reg       dout_valid    // Output valid pulse (1 cycle)
);

    reg [3:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default: valid low unless 8 bits collected

            if (din_valid) begin
                // Shift serial input into dout_parallel from MSB down to LSB
                dout_parallel <= {din_serial, dout_parallel[7:1]};
                
                if (cnt == 4'd7) begin
                    dout_valid <= 1'b1; // 8 bits collected
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule