module square_wave (
    input clk,
    input [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    wire toggle_condition;

    // Condition to toggle wave_out when count reaches freq-1
    assign toggle_condition = (count == freq - 1) && (freq != 0);

    always @(posedge clk) begin
        if (toggle_condition) begin
            count <= 0;
            wave_out <= ~wave_out;
        end else if (freq == 0) begin
            // Hold count and wave_out steady if freq=0 (no toggling)
            count <= 0;
            wave_out <= wave_out;
        end else begin
            count <= count + 1;
        end
    end

endmodule