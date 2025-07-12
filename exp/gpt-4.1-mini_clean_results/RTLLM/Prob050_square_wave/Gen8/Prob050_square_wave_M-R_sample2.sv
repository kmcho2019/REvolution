module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    reg [7:0] count;
    reg toggle;

    // Combinational logic for next count and toggle signal
    always @(*) begin
        if (freq == 8'd0 || freq == 8'd1) begin
            // For freq 0 or 1, hold count and disable toggle
            toggle = 1'b0;
        end else if (count == freq - 1) begin
            toggle = 1'b1;
        end else begin
            toggle = 1'b0;
        end
    end

    // Sequential logic for counter and output toggle
    always @(posedge clk) begin
        if (freq == 8'd0 || freq == 8'd1) begin
            // Hold wave_out steady and reset count
            count <= 8'd0;
        end else if (toggle) begin
            count <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 1'b1;
        end
    end

endmodule