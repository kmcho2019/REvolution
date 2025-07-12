module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] down_count;

    always @(posedge clk) begin
        if (rst) begin
            wave_out  <= 1'b0;
            down_count <= 8'd0;
        end else if (freq != 8'd0) begin
            if (down_count == 8'd0) begin
                wave_out  <= ~wave_out;
                down_count <= freq;
            end else begin
                down_count <= down_count - 8'd1;
            end
        end else begin
            // Hold outputs steady when freq=0
            wave_out  <= wave_out;
            down_count <= down_count;
        end
    end

endmodule