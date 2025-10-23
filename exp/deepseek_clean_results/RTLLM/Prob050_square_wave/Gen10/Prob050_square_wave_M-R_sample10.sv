module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    wire count_max = (count == (freq - 1)) && (freq != 0);

    always @(posedge clk) begin
        if (freq == 0) begin
            count <= 8'd0;
        end else begin
            count <= count_max ? 8'd0 : count + 1;
            wave_out <= count_max ? ~wave_out : wave_out;
        end
    end

    // Handle freq=0 case with continuous assignment
    assign wave_out = (freq == 0) ? 1'b0 : wave_out;

endmodule