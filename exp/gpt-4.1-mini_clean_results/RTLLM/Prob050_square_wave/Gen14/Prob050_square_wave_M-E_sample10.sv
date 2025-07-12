module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] counter;

    always @(posedge clk) begin
        if (rst) begin
            counter  <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            // Hold output steady and counter reset when freq is zero
            counter  <= 8'd0;
            wave_out <= wave_out;
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