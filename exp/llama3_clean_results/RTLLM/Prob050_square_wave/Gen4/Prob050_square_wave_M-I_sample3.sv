module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

// Use a local parameter to determine the counter's bit width based on the required frequency range
localparam bit_width = 8;

reg [bit_width-1:0] count = {bit_width{1'b0}};

always @(posedge clk) begin
    if (count == (freq - 1)) begin
        wave_out <= ~wave_out; // Toggle wave_out
        count <= {bit_width{1'b0}}; // Reset count to zero
    end else begin
        count <= count + {bit_width{1'b1}}; // Increment count
    end
end

endmodule