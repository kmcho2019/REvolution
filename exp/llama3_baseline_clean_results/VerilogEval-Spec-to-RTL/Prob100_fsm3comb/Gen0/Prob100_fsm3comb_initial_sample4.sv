module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case (state)
        2'b00: begin // State A
            if (!in) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
            out = 1'b0;
        end
        2'b01: begin // State B
            if (!in) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
            out = 1'b0;
        end
        2'b10: begin // State C
            if (!in) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b11;
            end
            out = 1'b0;
        end
        2'b11: begin // State D
            if (!in) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
            out = 1'b1;
        end
        default: begin
            next_state = 2'b00;
            out = 1'b0;
        end
    endcase
end

endmodule