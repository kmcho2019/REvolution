module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

reg [1:0] next_state_val;
reg out_val;

always @(in, state) begin
    case (state)
        2'b00: begin
            next_state_val = in ? 2'b01 : 2'b00;
            out_val = 0;
        end
        2'b01: begin
            next_state_val = in ? 2'b01 : 2'b10;
            out_val = 0;
        end
        2'b10: begin
            next_state_val = in ? 2'b11 : 2'b00;
            out_val = 0;
        end
        2'b11: begin
            next_state_val = in ? 2'b01 : 2'b10;
            out_val = 1;
        end
    endcase
    next_state = next_state_val;
    out = out_val;
end

endmodule