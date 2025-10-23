module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

always @(*) begin
    case(state)
        2'b00: begin // A
            out = 1'b0;
            next_state = in ? 2'b01 : 2'b00;
        end
        2'b01: begin // B
            out = 1'b0;
            next_state = in ? 2'b01 : 2'b10;
        end
        2'b10: begin // C
            out = 1'b0;
            next_state = in ? 2'b11 : 2'b00;
        end
        2'b11: begin // D
            out = 1'b1;
            next_state = in ? 2'b01 : 2'b10;
        end
        default: begin
            out = 1'b0;
            next_state = 2'b00;
        end
    endcase
end

endmodule