module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

always @(*) begin
    case (q)
        4'b0001: next_q = 4'b0010;
        4'b0010: next_q = 4'b0011;
        4'b0011: next_q = 4'b0100;
        4'b0100: next_q = 4'b0101;
        4'b0101: next_q = 4'b0110;
        4'b0110: next_q = 4'b0111;
        4'b0111: next_q = 4'b1000;
        4'b1000: next_q = 4'b1001;
        4'b1001: next_q = 4'b1010;
        4'b1010: next_q = 4'b0001;
        default: next_q = 4'b0001;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;
    end else begin
        q <= next_q;
    end
end

endmodule