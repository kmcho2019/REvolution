module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (q == 4'b1111) begin
        next_q = 4'b0000;
    end
    else begin
        // Temperature-code inspired counting
        case (q)
            4'b0000: next_q = 4'b0001;
            4'b0001: next_q = 4'b0011;
            4'b0010: next_q = 4'b0011;
            4'b0011: next_q = 4'b0111;
            4'b0100: next_q = 4'b0111;
            4'b0101: next_q = 4'b0111;
            4'b0110: next_q = 4'b0111;
            4'b0111: next_q = 4'b1111;
            4'b1000: next_q = 4'b1111;
            4'b1001: next_q = 4'b1111;
            4'b1010: next_q = 4'b1111;
            4'b1011: next_q = 4'b1111;
            4'b1100: next_q = 4'b1111;
            4'b1101: next_q = 4'b1111;
            4'b1110: next_q = 4'b1111;
            default: next_q = q + 1;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        q <= next_q;
    end
end

endmodule