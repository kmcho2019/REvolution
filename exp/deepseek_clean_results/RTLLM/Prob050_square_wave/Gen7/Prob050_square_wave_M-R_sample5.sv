module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;
    wire toggle = (count == 8'd0);
    wire [7:0] next_count = toggle ? freq : (count - 1);

    always @(posedge clk) begin
        count <= next_count;
        if (toggle) wave_out <= ~wave_out;
    end

endmodule