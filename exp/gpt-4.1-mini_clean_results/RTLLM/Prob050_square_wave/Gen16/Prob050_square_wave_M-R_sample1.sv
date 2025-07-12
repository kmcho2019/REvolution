module square_wave (
    input  wire        clk,
    input  wire        rst_n,     // Active-low asynchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    // Terminal count: when count equals freq-1 and freq != 0
    wire freq_nonzero = (freq != 8'd0);
    wire [7:0] freq_minus1 = freq - 8'd1;
    wire count_tc = freq_nonzero && (count == freq_minus1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else if (!freq_nonzero) begin
            count    <= 8'd0;
            // wave_out holds value without toggling
        end else if (count_tc) begin
            count    <= 8'd0;
            wave_out <= ~wave_out;
        end else begin
            count <= count + 8'd1;
            // wave_out holds value without toggling
        end
    end

endmodule