module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            cnt           <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output this cycle
            
            if (din_valid) begin
                // Shift right by 1, insert new bit at MSB
                // This places first received bit in MSB after 8 inputs
                shift_reg <= {din_serial, shift_reg[7:1]};
                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // 8 bits received, output parallel data and set valid
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid <= 1'b1;
                    cnt <= 4'b0; // reset counter for next data set
                end
            end
        end
    end

endmodule