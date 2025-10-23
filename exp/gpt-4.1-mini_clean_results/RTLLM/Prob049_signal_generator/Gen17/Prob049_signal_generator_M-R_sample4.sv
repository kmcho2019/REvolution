module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // Direction: +1 or -1 represented by signed 1-bit reg (1 or -1)
    reg signed [0:0] direction; // 1 means increment, 0 means decrement (encoded as +1/-1)

    // next_wave computed combinationally
    wire signed [5:0] next_wave_signed;
    assign next_wave_signed = {1'b0, wave} + (direction ? 6'sd1 : -6'sd1);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b1; // start incrementing
        end else begin
            wave <= next_wave_signed[4:0];

            // Reverse direction if boundaries reached
            if (wave == 5'd31)
                direction <= 1'b0; // decrement
            else if (wave == 5'd0)
                direction <= 1'b1; // increment
        end
    end

endmodule