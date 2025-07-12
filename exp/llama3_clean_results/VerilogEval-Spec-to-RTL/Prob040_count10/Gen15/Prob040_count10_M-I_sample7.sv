module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

// Gray code encoding for 4-bit counter
// 0: 0000, 1: 0001, 2: 0011, 3: 0010, 4: 0110, 5: 0111, 6: 0101, 7: 0100, 8: 1100, 9: 1101
reg [3:0] gray_code [9:0];

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
    end else if (state == 4'd9) begin
        state <= 4'd0;
    end else begin
        state <= state + 1;
    end
end

// Use Gray code encoding for state register
always @(*) begin
    case (state)
        4'd0: gray_code[0] = 4'd0;
        4'd1: gray_code[1] = 4'd1;
        4'd2: gray_code[2] = 4'd3;
        4'd3: gray_code[3] = 4'd2;
        4'd4: gray_code[4] = 4'd6;
        4'd5: gray_code[5] = 4'd7;
        4'd6: gray_code[6] = 4'd5;
        4'd7: gray_code[7] = 4'd4;
        4'd8: gray_code[8] = 4'd12;
        4'd9: gray_code[9] = 4'd13;
    endcase
end

assign q = gray_code[state];

endmodule