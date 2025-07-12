module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [5:0] count;
    wire counter_enable = |freq;
    wire counter_clear = (count == 0);
    
    // Counter logic
    always @(posedge clk) begin
        if (counter_enable) begin
            if (counter_clear)
                count <= freq[5:0];
            else
                count <= count - 1;
        end
    end

    // Output generation - toggles when counter wraps
    assign wave_out = ^count;  // XOR all bits for toggle effect

endmodule