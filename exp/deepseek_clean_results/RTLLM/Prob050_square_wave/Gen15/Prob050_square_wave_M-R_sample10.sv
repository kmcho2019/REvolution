module square_wave (
    input clk,
    input [7:0] freq,
    output wave_out
);

    reg [7:0] count;
    wire count_enable = |freq;  // Enable when freq is non-zero
    wire counter_load = (count == 8'd0);  // Parallel load control
    
    // Counter with parallel load
    always @(posedge clk) begin
        if (count_enable) begin
            count <= counter_load ? freq : (count - 1);
        end
    end

    // Output generation - toggles when counter wraps
    assign wave_out = count[7];  // MSB gives square wave output

endmodule