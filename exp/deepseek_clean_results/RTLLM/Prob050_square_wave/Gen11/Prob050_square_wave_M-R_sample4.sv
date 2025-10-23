module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    
    // Combinational logic
    wire counter_max = (freq != 0) && (count == (freq - 1));
    wire counter_enable = (freq != 0) && (~freq[7] || (count != 0));
    
    // Sequential logic
    always @(posedge clk) begin
        if (counter_enable) begin
            count <= counter_max ? 8'd0 : count + 1;
            wave_out <= counter_max ? ~wave_out : wave_out;
        end
        else if (freq == 0) begin
            wave_out <= 1'b0;
        end
    end

endmodule