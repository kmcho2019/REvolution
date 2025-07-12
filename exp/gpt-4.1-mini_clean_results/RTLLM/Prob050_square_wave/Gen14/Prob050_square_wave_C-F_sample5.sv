module square_wave (
    input  wire        clk,
    input  wire        rst,      // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    // Terminal count: when count equals freq-1 and freq != 0
    wire freq_nonzero = (freq != 8'd0);
    wire [7:0] freq_minus1 = freq - 8'd1;
    wire count_tc = freq_nonzero && (count == freq_minus1);

    // Counter increments only when freq != 0; else holds zero to save switching
    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else if (!freq_nonzero) begin
            count <= 8'd0;
        end else if (count_tc) begin
            count <= 8'd0;
        end else begin
            count <= count + 8'd1;
        end
    end

    // Toggle wave_out on terminal count; hold value otherwise
    always @(posedge clk) begin
        if (rst) begin
            wave_out <= 1'b0;
        end else if (count_tc) begin
            wave_out <= ~wave_out;
        end else begin
            wave_out <= wave_out;
        end
    end

endmodule