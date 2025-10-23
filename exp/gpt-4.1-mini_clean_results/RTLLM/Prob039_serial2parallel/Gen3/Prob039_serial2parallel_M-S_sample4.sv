module serial2parallel (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       din_serial,
    input  wire       din_valid,
    output reg  [7:0] dout_parallel,
    output reg        dout_valid
);

    reg [3:0] count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            count        <= 4'd0;
            shift_reg    <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output each cycle
            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};
                count <= count + 1;

                if (count == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    count <= 4'd0;
                end
            end
        end
    end

endmodule