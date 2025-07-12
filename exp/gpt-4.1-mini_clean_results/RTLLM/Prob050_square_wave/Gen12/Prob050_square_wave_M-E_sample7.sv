module square_wave (
    input  wire        clk,
    input  wire        rst,      // Asynchronous active-high reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] countdown;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            countdown <= 8'd0;
            wave_out  <= 1'b0;
        end else begin
            if (freq == 8'd0) begin
                countdown <= 8'd0;
                wave_out  <= wave_out;   // Hold steady when disabled
            end else begin
                if (countdown == 8'd0) begin
                    countdown <= freq;
                    wave_out  <= ~wave_out;
                end else begin
                    countdown <= countdown - 8'd1;
                end
            end
        end
    end

endmodule