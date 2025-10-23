module square_wave (
    input  wire        clk,
    input  wire        rst,       // Active-high synchronous reset
    input  wire [7:0]  freq,
    output reg         wave_out
);

    reg [7:0] count;

    // Terminal count condition when count reaches freq - 1 and freq != 0
    wire count_tc = (freq != 8'd0) && (count == (freq - 8'd1));

    // Counter logic: increments until terminal count, then resets
    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else if (freq == 8'd0) begin
            count <= 8'd0;
        end else if (count_tc) begin
            count <= 8'd0;
        end else begin
            count <= count + 8'd1;
        end
    end

    // wave_out toggling on terminal count
    always @(posedge clk) begin
        if (rst) begin
            wave_out <= 1'b0;
        end else if (count_tc) begin
            wave_out <= ~wave_out;
        end else begin
            wave_out <= wave_out; // hold current state
        end
    end

endmodule