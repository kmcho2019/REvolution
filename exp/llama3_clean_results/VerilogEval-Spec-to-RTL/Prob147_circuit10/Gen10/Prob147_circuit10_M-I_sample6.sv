module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

initial begin
    state = 1'b0;
    q = 1'b0;
end

always @(posedge clk) begin
    case({a, b})
        2'b01: state <= 1'b1;
        2'b11: state <= 1'b0;
        default: state <= state;
    endcase
end

always @(a, b, state) begin
    if (state == 1'b1 || (a == 1'b1 && b == 1'b0)) begin
        q = 1'b1;
    end else begin
        q = 1'b0;
    end
end

endmodule