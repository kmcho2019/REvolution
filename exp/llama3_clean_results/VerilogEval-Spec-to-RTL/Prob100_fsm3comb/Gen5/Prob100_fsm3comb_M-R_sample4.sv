module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

reg [1:0] ns;
reg o;

always @(*)
begin
    case(state)
        2'b00: begin // State A
            ns = (in)? 2'b01 : 2'b00;
            o = 1'b0;
        end
        2'b01: begin // State B
            ns = (in)? 2'b01 : 2'b10;
            o = 1'b0;
        end
        2'b10: begin // State C
            ns = (in)? 2'b11 : 2'b00;
            o = 1'b0;
        end
        2'b11: begin // State D
            ns = (in)? 2'b01 : 2'b10;
            o = 1'b1;
        end
        default: begin
            ns = 2'b00;
            o = 1'b0;
        end
    endcase
end

assign next_state = ns;
assign out = o;

endmodule