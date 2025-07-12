module square_wave (
    input        clk,
    input        rst_n,      // Active low synchronous reset
    input  [7:0] freq,
    output reg   wave_out
);

    reg [7:0] count;
    wire [7:0] threshold;
    wire toggle_condition;

    // threshold is freq - 1, combinational
    assign threshold = (freq == 8'd0) ? 8'd0 : freq - 1;

    // toggle when count reaches threshold and freq is not zero
    assign toggle_condition = (freq != 8'd0) && (count == threshold);

    always @(posedge clk) begin
        if (!rst_n) begin
            count <= 8'd0;
            wave_out <= 1'b0;
        end else if (freq == 8'd0) begin
            count <= 8'd0;      // hold count at zero if freq=0 (disable toggling)
            wave_out <= wave_out; // maintain wave_out without toggling
        end else if (toggle_condition) begin
            count <= 8'd0;      // reset count at threshold
            wave_out <= ~wave_out; // toggle output
        end else begin
            count <= count + 1'b1; // increment count
            wave_out <= wave_out;  // hold output stable
        end
    end

endmodule