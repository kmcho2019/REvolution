module square_wave (
    input  wire        clk,
    input  wire        rst_n,    // Active-low asynchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter  <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            counter  <= 8'd0;
            wave_out <= wave_out; // Hold steady if freq is zero
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