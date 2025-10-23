module TopModule (
    input           clk,
    input           a,
    output reg [2:0] q
);

reg [2:0] next_state;

always @(*) begin
    if (a) begin
        next_state = 3'd4;
    end else begin
        case (q)
            3'd4: next_state = 3'd5;
            3'd5: next_state = 3'd6;
            3'd6: next_state = 3'd0;
            3'd0: next_state = 3'd1;
            3'd1: next_state = 3'd2;
            3'd2: next_state = 3'd3;
            3'd3: next_state = 3'd4;
            default: next_state = 3'd4;
        endcase
    end
end

// Optional power optimization: update q only if next_state differs
always @(posedge clk) begin
    if (q !== next_state) begin
        q <= next_state;
    end
end

endmodule