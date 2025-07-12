module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

reg [1:0] next_state_lut [4] = '{2'b00, 2'b01, 2'b10, 2'b11};
reg [3:0] out_lut [4] = '{4'b0000, 4'b0000, 4'b0000, 4'b1000};

always @(in, state) begin
    case (state)
        2'b00: next_state = in? next_state_lut[1] : next_state_lut[0];
        2'b01: next_state = in? next_state_lut[1] : next_state_lut[2];
        2'b10: next_state = in? next_state_lut[3] : next_state_lut[0];
        2'b11: next_state = in? next_state_lut[1] : next_state_lut[2];
    endcase
    
    out = out_lut[state][in];
end

endmodule