module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

initial begin
    state = 2'b00;
end

always @(posedge clock) begin
    case (state)
        2'b00: begin
            if (a)
                state <= 2'b01;
            else
                state <= 2'b00;
        end
        2'b01: begin
            if (a)
                state <= 2'b10;
            else
                state <= 2'b01;
        end
        2'b10: begin
            if (a)
                state <= 2'b11;
            else
                state <= 2'b10;
        end
        2'b11: begin
            if (a)
                state <= 2'b00;
            else
                state <= 2'b11;
        end
        default: state <= 2'b00;
    endcase
end

always @(*) begin
    p = state[1];
    q = state[0];
end

endmodule