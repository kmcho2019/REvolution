module square_wave (
    input  wire        clk,
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] countdown;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            countdown <= 8'd0;
            wave_out <= wave_out; // Hold output steady if freq=0
        end else if (countdown == 8'd0) begin
            countdown <= freq;
            wave_out <= ~wave_out; // Toggle output when countdown reaches zero
        end else begin
            countdown <= countdown - 8'd1;
        end
    end

endmodule