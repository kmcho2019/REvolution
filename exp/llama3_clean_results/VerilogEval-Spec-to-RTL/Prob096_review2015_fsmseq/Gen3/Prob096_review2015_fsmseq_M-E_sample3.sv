module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register
reg detected; // flag to indicate sequence detection

always @(posedge clk) begin
    if (reset) begin // reset is active high
        shift_reg <= 4'b0000; // reset shift register
        detected <= 0; // reset detected flag
        start_shifting <= 0; // reset start_shifting to 0
    end else begin
        shift_reg <= {shift_reg[2:0], data}; // shift in new data
        if (shift_reg == 4'b1101 &&!detected) begin // check for sequence match
            detected <= 1; // set detected flag
        end
        if (detected) begin // if sequence detected
            start_shifting <= 1; // set start_shifting to 1
        end else begin
            start_shifting <= 0; // reset start_shifting to 0
        end
    end
end

endmodule