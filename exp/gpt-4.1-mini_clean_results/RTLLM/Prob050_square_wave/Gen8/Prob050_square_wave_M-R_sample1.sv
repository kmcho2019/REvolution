module square_wave (
    input        clk,
    input        rst_n,        // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire count_max;

    assign count_max = (freq != 8'd0) && (count == freq - 8'd1);

    // Counter: increments on clk unless freq==0 or reset active
    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
        end else if (freq == 8'd0) begin
            count <= 8'd0;  // freeze count when freq is zero
        end else if (count_max) begin
            count <= 8'd0;
        end else begin
            count <= count + 1'b1;
        end
    end

    // wave_out toggling logic
    always @(posedge clk) begin
        if (!rst_n) begin
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            wave_out <= wave_out;  // hold steady when freq=0
        end else if (count_max) begin
            wave_out <= ~wave_out; // toggle when count reaches freq-1
        end
    end

endmodule