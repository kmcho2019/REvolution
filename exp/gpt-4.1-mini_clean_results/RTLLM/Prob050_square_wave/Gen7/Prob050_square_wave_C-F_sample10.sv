module square_wave (
    input        clk,
    input        rst,       // Synchronous active-high reset for robustness
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;

    // Threshold: freq - 1, zero if freq is 0 to prevent underflow
    wire [7:0] threshold = (freq == 8'd0) ? 8'd0 : (freq - 1);

    // Clock enable: enable counting and toggling only if freq > 1 to avoid unnecessary toggling/counting
    wire clk_en = (freq > 8'd1);

    // toggle request combinational: when count reaches threshold and freq > 1
    wire toggle_req = clk_en && (count == threshold);

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (!clk_en) begin
            // Hold wave_out steady and reset count when freq <= 1
            count <= 8'd0;
        end else if (toggle_req) begin
            // Toggle wave_out and reset count
            wave_out <= ~wave_out;
            count    <= 8'd0;
        end else begin
            // Increment counter
            count <= count + 1'b1;
        end
    end

endmodule