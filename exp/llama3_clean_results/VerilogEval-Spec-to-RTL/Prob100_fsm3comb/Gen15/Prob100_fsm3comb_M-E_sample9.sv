module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

reg [1:0] next_state_array [4][2];
reg [0:0] out_array [4][2];

initial begin
    next_state_array[0][0] = 2'b00; // A, in=0
    next_state_array[0][1] = 2'b01; // A, in=1
    next_state_array[1][0] = 2'b10; // B, in=0
    next_state_array[1][1] = 2'b01; // B, in=1
    next_state_array[2][0] = 2'b00; // C, in=0
    next_state_array[2][1] = 2'b11; // C, in=1
    next_state_array[3][0] = 2'b10; // D, in=0
    next_state_array[3][1] = 2'b01; // D, in=1
    
    out_array[0][0] = 1'b0; // A, in=0
    out_array[0][1] = 1'b0; // A, in=1
    out_array[1][0] = 1'b0; // B, in=0
    out_array[1][1] = 1'b0; // B, in=1
    out_array[2][0] = 1'b0; // C, in=0
    out_array[2][1] = 1'b0; // C, in=1
    out_array[3][0] = 1'b1; // D, in=0
    out_array[3][1] = 1'b1; // D, in=1
end

assign next_state = next_state_array[state][in];
assign out = out_array[state][in];

endmodule