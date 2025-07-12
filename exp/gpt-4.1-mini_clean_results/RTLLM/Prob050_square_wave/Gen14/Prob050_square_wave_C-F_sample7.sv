module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;
    wire      toggle_flag;

    // Toggle when count reaches freq-1 and freq != 0
    assign toggle_flag = (freq != 8'd0) && (count == freq - 1);

    always @(posedge clk) begin
        if (rst) begin
            count    <= 8'd0;
            wave_out <= 1'b0;
        end else begin
            if (toggle_flag) begin
                count    <= 8'd0;
                wave_out <= ~wave_out;
            end else if (freq != 8'd0) begin
                count <= count + 8'd1;
            end else begin
                count <= 8'd0;  // Hold count when freq=0
                // wave_out holds its value implicitly
            end
        end
    end

endmodule