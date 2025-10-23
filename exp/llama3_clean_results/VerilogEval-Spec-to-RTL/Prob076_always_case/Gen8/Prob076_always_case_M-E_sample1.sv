module param_mux #(
    parameter NUM_INPUTS = 6,
    parameter INPUT_WIDTH = 4,
    parameter SEL_WIDTH = 3
)(
    input [SEL_WIDTH-1:0] sel,
    input [INPUT_WIDTH-1:0] data [NUM_INPUTS-1:0],
    output reg [INPUT_WIDTH-1:0] out
);

always @(*) begin
    case (sel)
        3'b000: out = data[0];
        3'b001: out = data[1];
        3'b010: out = data[2];
        3'b011: out = data[3];
        3'b100: out = data[4];
        3'b101: out = data[5];
        default: out = {INPUT_WIDTH{1'b0}};
    endcase
end

endmodule

module TopModule(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);

wire [3:0] data [5:0];
assign data[0] = data0;
assign data[1] = data1;
assign data[2] = data2;
assign data[3] = data3;
assign data[4] = data4;
assign data[5] = data5;

param_mux #(
    .NUM_INPUTS(6),
    .INPUT_WIDTH(4),
    .SEL_WIDTH(3)
) u_mux (
    .sel(sel),
    .data(data),
    .out(out)
);

endmodule