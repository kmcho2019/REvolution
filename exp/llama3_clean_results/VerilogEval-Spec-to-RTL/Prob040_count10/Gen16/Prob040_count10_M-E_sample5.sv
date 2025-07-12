module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;
reg [3:0] gray_state;

// Gray code encoder
always @(state) begin
    case (state)
        4'd0: gray_state = 4'd0;
        4'd1: gray_state = 4'd1;
        4'd2: gray_state = 4'd3;
        4'd3: gray_state = 4'd2;
        4'd4: gray_state = 4'd6;
        4'd5: gray_state = 4'd7;
        4'd6: gray_state = 4'd5;
        4'd7: gray_state = 4'd4;
        4'd8: gray_state = 4'd12;
        4'd9: gray_state = 4'd13;
    endcase
end

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
    end else if (state == 4'd9) begin
        state <= 4'd0;
    end else begin
        state <= state + 1;
    end
end

// Gray code decoder
always @(gray_state) begin
    case (gray_state)
        4'd0: q = 4'd0;
        4'd1: q = 4'd1;
        4'd3: q = 4'd2;
        4'd2: q = 4'd3;
        4'd6: q = 4'd4;
        4'd7: q = 4'd5;
        4'd5: q = 4'd6;
        4'd4: q = 4'd7;
        4'd12: q = 4'd8;
        4'd13: q = 4'd9;
    endcase
end

endmodule