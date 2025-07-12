module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count = 0;
    
    // Combinational logic
    wire freq_valid = (freq != 0);
    wire count_max = freq_valid && (count == (freq - 1));
    wire count_enable = freq_valid && (~freq[7] || (count != 0));
    
    // Next state logic
    wire [7:0] next_count = count_max ? 8'd0 : (count + 1);
    wire next_wave = count_max ? ~wave_out : wave_out;
    
    // Sequential logic
    always @(posedge clk) begin
        if (count_enable) begin
            count <= next_count;
            wave_out <= next_wave;
        end
    end

endmodule