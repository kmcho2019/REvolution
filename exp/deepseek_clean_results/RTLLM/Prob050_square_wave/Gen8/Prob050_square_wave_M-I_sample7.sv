module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire counter_done = (count == 0);
    
    always @(posedge clk) begin
        if (freq == 0) begin
            wave_out <= 1'b0;       // Static low when freq=0
            count <= 8'd0;         // Hold counter at 0
        end else if (counter_done) begin
            wave_out <= ~wave_out; // Toggle output
            count <= freq - 1;      // Reload counter
        end else begin
            count <= count - 1;    // Count down
        end
    end

endmodule