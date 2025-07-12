module square_wave(
    input clk,
    input [7:0] freq,
    output reg wave_out
);

reg [7:0] count;  // Counter register
reg wave_out_reg;  // Internal wave output register

always @(posedge clk) begin
    if (count == freq - 1) begin
        wave_out_reg <= ~wave_out_reg;  // Toggle the wave output
        count <= 0;  // Reset the counter
    end else begin
        count <= count + 1;  // Increment the counter
    end
end

assign wave_out = wave_out_reg;  // Assign the internal wave output to the output port

initial begin
    wave_out_reg = 0;  // Initialize the wave output to 0
    count = 0;  // Initialize the counter to 0
end

endmodule