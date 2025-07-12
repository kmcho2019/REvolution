module square_wave (
    input        clk,
    input        rst,
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire      toggle_flag;

    // Toggle flag asserted when count reaches freq-1 (and freq!=0)
    assign toggle_flag = (freq != 8'd0) && (count == freq - 1);

    // Counter increments or resets on toggle_flag
    always @(posedge clk) begin
        if (rst) begin
            count <= 8'd0;
        end else begin
            if (toggle_flag)
                count <= 8'd0;
            else if (freq != 8'd0)
                count <= count + 1'b1;
            else
                count <= 8'd0;  // Hold count if freq=0
        end
    end

    // wave_out toggles on toggle_flag
    always @(posedge clk) begin
        if (rst) begin
            wave_out <= 1'b0;
        end else if (toggle_flag) begin
            wave_out <= ~wave_out;
        end else begin
            wave_out <= wave_out; // Hold current value
        end
    end

endmodule