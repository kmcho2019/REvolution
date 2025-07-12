module square_wave (
    input        clk,
    input        rst_n,        // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] counter;
    wire      zero;
    wire      active;

    assign active = (freq != 8'd0);
    assign zero = (counter == 8'd0);

    always @(posedge clk) begin
        if (!rst_n) begin
            wave_out <= 1'b0;
            counter  <= 8'd0;
        end else if (active) begin
            if (zero) begin
                wave_out <= ~wave_out;
                counter  <= freq;
            end else begin
                counter <= counter - 1'b1;
            end
        end else begin
            // When freq is zero, hold outputs steady
            counter  <= 8'd0;
            wave_out <= wave_out;
        end
    end

endmodule