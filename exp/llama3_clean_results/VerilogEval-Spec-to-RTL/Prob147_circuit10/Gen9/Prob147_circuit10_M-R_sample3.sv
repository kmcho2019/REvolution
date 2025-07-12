module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

reg nextState;

always @(posedge clk) begin
    case(state)
        1'b0: begin
            if (~a && b) begin
                state <= 1'b1;
            end else if (a && b) begin
                state <= 1'b0;
            end else begin
                state <= 1'b0;
            end
        end
        1'b1: begin
            if (~a && b) begin
                state <= 1'b1;
            end else if (a && b) begin
                state <= 1'b1;
            end else begin
                state <= 1'b0;
            end
        end
        default: state <= 1'b0;
    endcase
end

assign q = (state == 1'b1) || (state == 1'b0 && ~a && b);

endmodule