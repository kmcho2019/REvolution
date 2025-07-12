module square_wave (
    input  wire       clk,
    input  wire       rst,       // Active-high synchronous reset
    input  wire [7:0] freq,
    output wire       wave_out
);

    reg [7:0] count;

    // Synchronous reset and counter increment
    always @(posedge clk) begin
        if (rst)
            count <= 8'd0;
        else
            count <= count + 8'd1;
    end

    // Generate wave_out combinationally as a wire
    // Output is high when count < freq/2, else low.
    // When freq=0, output is low.
    assign wave_out = (freq == 8'd0) ? 1'b0 : (count < (freq >> 1));

endmodule