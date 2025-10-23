module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [1:0] state; // 2-bit state register
parameter HOLD = 2'b00, COUNT = 2'b01, WRAP = 2'b10;

always @(posedge clk) begin
    case (state)
        HOLD: begin
            if (!a) state <= COUNT;
            q <= 4;
        end
        COUNT: begin
            if (q == 7) state <= WRAP;
            else state <= COUNT;
            q <= q + 1;
        end
        WRAP: begin
            state <= COUNT;
            q <= 0;
        end
    endcase
end

initial begin
    state <= HOLD;
    q <= 4;
end

endmodule