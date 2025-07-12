// Novel module using a shift register approach to reverse bit ordering
module TopModule(
    input  clk, // Clock signal
    input  rst_n, // Active low reset
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    reg [7:0] out_reg; // Output register
    reg [2:0] counter; // Counter to control shifting

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin // Reset condition
            out_reg <= 8'd0; // Reset output register
            counter <= 3'd0; // Reset counter
        end else if (counter < 3'd8) begin // Shifting process
            out_reg <= {out_reg[6:0], in[7-counter]}; // Shift and insert bit
            counter <= counter + 1'd1; // Increment counter
        end else begin // Shifting completed
            out_reg <= out_reg; // Hold output
            counter <= 3'd8; // Counter max value
        end
    end

    assign out = out_reg; // Assign output register to output

endmodule