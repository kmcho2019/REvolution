module square_wave #(
    parameter INIT_WAVE_OUT = 1'b0
)(
    input  wire        clk,
    input  wire        rst_n,       // Asynchronous active-low reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= INIT_WAVE_OUT;
        end else begin
            if (freq == 8'd0) begin
                // Hold output and count steady when freq=0
                count <= 8'd0;
                wave_out <= wave_out;
            end else begin
                if (count == 8'd0) begin
                    count    <= freq;
                    wave_out <= ~wave_out;
                end else begin
                    count <= count - 8'd1;
                    wave_out <= wave_out;
                end
            end
        end
    end

endmodule