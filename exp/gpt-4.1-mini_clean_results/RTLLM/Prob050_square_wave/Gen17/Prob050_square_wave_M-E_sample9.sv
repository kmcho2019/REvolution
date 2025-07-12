module square_wave (
    input  wire        clk,
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // When freq=0, hold output low and reset counter
            count <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            if (count == freq - 1) begin
                count <= 8'd0;
                wave_out <= ~wave_out;  // toggle output
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule