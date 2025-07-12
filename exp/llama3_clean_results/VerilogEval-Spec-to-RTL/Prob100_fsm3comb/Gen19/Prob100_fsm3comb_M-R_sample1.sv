module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :
                   (state == 2'b01) ? (in ? 2'b01 : 2'b10) :
                   (state == 2'b10) ? (in ? 2'b11 : 2'b00) :
                   (in ? 2'b01 : 2'b10);

assign out = (state == 2'b11);

endmodule