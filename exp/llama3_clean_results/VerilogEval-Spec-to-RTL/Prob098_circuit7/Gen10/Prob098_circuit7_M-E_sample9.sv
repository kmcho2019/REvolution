module TopModule(
    input clk,
    input a,
    output reg q
);

reg state;
initial state = 0;
initial q = 1;

always @(posedge clk) begin
    case(state)
        0: begin
            if (~a) begin
                state <= 0;
                q <= 1'b1;
            end else begin
                state <= 1;
                q <= 1'b0;
            end
        end
        1: begin
            state <= 1;
            q <= 1'b0;
        end
    endcase
end

endmodule