module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

wire [3:0] state_onehot;
assign state_onehot[0] = (state == 2'b00);
assign state_onehot[1] = (state == 2'b01);
assign state_onehot[2] = (state == 2'b10);
assign state_onehot[3] = (state == 2'b11);

reg [1:0] next_state_A, next_state_B, next_state_C, next_state_D;
assign next_state_A = in ? 2'b01 : 2'b00;
assign next_state_B = in ? 2'b01 : 2'b10;
assign next_state_C = in ? 2'b11 : 2'b00;
assign next_state_D = in ? 2'b01 : 2'b10;

assign next_state = (state_onehot[0] ? next_state_A :
                    state_onehot[1] ? next_state_B :
                    state_onehot[2] ? next_state_C :
                    state_onehot[3] ? next_state_D : 2'b00);

assign out = state_onehot[3];

endmodule