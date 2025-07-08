module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg      out
);

always @(*) begin
    case(state)
        2'b00: begin // State A
            out = 1'b0;
            next_state = in ? 2'b01 : 2'b00; // in=1 -> B, in=0 -> A
        end
        2'b01: begin // State B
            out = 1'b0;
            next_state = in ? 2'b01 : 2'b10; // in=1 -> B, in=0 -> C
        end
        2'b10: begin // State C
            out = 1'b0;
            next_state = in ? 2'b11 : 2'b00; // in=1 -> D, in=0 -> A
        end
        2'b11: begin // State D
            out = 1'b1;
            next_state = in ? 2'b01 : 2'b10; // in=1 -> B, in=0 -> C
        end
        default: begin
            out = 1'b0;
            next_state = 2'b00; // default to A
        end
    endcase
end

endmodule