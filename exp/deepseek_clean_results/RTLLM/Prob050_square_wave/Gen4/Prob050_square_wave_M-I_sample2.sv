module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out = 0
);

    reg [7:0] count;
    wire active = |freq;  // Combinational check for freq!=0

    always @(posedge clk) begin
        if (active) begin
            if (count == 1) begin
                wave_out <= ~wave_out;
                count <= freq;
            end else begin
                count <= count - 1;
            end
        end
        else begin
            wave_out <= 1'b0;
        end
    end

    // Initialize counter
    initial begin
        count = freq;
    end

endmodule