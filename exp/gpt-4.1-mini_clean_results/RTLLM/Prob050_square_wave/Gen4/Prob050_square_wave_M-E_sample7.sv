module square_wave (
    input        clk,
    input        rst_n,      // Active-low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            counter  <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            if (counter == 8'd0) begin
                counter  <= freq;
                wave_out <= ~wave_out;
            end else begin
                counter <= counter - 8'd1;
            end
        end
    end

endmodule