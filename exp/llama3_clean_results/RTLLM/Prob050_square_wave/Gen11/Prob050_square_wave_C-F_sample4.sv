module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count = 8'd0;  // Counter register
reg wave_state = 1'b0;  // Register to track the state of the output signal

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        count <= 8'd0;
        wave_state <= ~wave_state;
    end else begin
        count <= count + 8'd1;
    end
end

always @(*) begin
    wave_out = wave_state;
end

endmodule