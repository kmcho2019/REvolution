module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] count;

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            count         <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default

            if (din_valid) begin
                // Shift left, insert new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                if (count == 3'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial}; // output assembled data
                    dout_valid    <= 1'b1;                         // valid for one cycle
                    count         <= 3'b0;                          // reset counter
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule