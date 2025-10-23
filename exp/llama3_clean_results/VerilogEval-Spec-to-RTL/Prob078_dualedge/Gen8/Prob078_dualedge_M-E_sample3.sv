module TopModule(
    input clk,
    input d,
    output reg q
);

reg [1:0] state;
reg internal_clk;

always @(posedge clk or negedge clk) begin
    internal_clk <= ~internal_clk;
end

always @(posedge internal_clk) begin
    case (state)
        2'b00: begin
            q <= d;
            state <= 2'b01;
        end
        2'b01: begin
            q <= d;
            state <= 2'b10;
        end
        2'b10: begin
            q <= d;
            state <= 2'b11;
        end
        2'b11: begin
            q <= d;
            state <= 2'b00;
        end
    endcase
end

initial begin
    internal_clk = 0;
    state = 2'b00;
end

endmodule