module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg [1:0] state
);

always @(posedge clk) begin
    case(state)
        2'b00: begin
            if (a == 1'b0 && b == 1'b1) begin
                state <= 2'b01;
            end else if (a == 1'b1 && b == 1'b0) begin
                state <= 2'b10;
            end
        end
        2'b01: begin
            if (a == 1'b1 && b == 1'b1) begin
                state <= 2'b00;
            end
        end
        2'b10: begin
            if (a == 1'b0 && b == 1'b1) begin
                state <= 2'b01;
            end else if (a == 1'b0 && b == 1'b0) begin
                state <= 2'b00;
            end
        end
        default: state <= 2'b00;
    endcase
end

assign q = (state == 2'b01) || (state == 2'b10) || (a &&!b);

endmodule