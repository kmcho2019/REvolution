module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    
    // Combinational logic
    wire counter_max = (count == (freq - 1));
    wire counter_reset = (freq == 0) || counter_max;
    wire [7:0] next_count = counter_reset ? 8'd0 : (count + 1);
    wire next_wave = (freq == 0) ? 1'b0 : (counter_max ? ~wave_out : wave_out);
    
    // Clock gating control
    wire update_enable = (freq != 0) && (~freq[7] || (count != 0));

    // Sequential logic
    always @(posedge clk) begin
        if (update_enable) begin
            count <= next_count;
            wave_out <= next_wave;
        end
        else if (freq == 0) begin
            wave_out <= 1'b0;
        end
    end

endmodule