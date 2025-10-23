module square_wave(
    input        clk,
    input  [7:0] freq,
    output reg   wave_out
);

    reg  [7:0] count;
    wire [7:0] target = freq - 8'd1;
    wire       reached = (count == target);

    always @(posedge clk) begin
        if (reached) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
        end
    end

endmodule