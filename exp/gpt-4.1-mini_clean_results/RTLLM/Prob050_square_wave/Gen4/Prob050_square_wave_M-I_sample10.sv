module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire enable = (freq != 0);

    always @(posedge clk) begin
        if (!enable) begin
            count <= 0;
            wave_out <= wave_out; // hold current state
        end else begin
            // Increment count and check overflow at freq-1
            if (count == freq - 1) begin
                count <= 0;
                wave_out <= ~wave_out;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule