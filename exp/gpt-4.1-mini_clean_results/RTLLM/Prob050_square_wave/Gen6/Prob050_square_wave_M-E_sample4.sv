module square_wave (
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (freq == 8'd0) begin
            // Freeze output and counter when freq=0
            count <= 8'd0;
            wave_out <= wave_out;
        end else if (count == freq - 1) begin
            // Toggle output and reset count
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            // Increment count
            count <= count + 1'b1;
        end
    end

endmodule