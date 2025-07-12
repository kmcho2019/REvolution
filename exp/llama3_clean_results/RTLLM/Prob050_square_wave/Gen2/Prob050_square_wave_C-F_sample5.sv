module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

// Counter register to track cycles between wave toggles
reg [7:0] count;

// Always block to handle clock edge and toggle wave_out
always @(posedge clk) begin
    if (count == (freq - 1)) begin
        // Reset counter and toggle wave_out when count reaches freq - 1
        wave_out <= ~wave_out;
        count <= 0;
    end else begin
        // Increment counter if it has not reached freq - 1
        count <= count + 1;
    end
end

// Initial block to set initial values for wave_out and count
initial begin
    wave_out = 0;
    count = 0;
end

endmodule