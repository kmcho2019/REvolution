module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg toggle_state;  // Register to track toggle state

always @(posedge clk) begin
    if (count == freq - 1) begin
        count <= 0;
        toggle_state <= ~toggle_state;
    end else begin
        count <= count + 1;
    end
    wave_out <= toggle_state;
end

endmodule