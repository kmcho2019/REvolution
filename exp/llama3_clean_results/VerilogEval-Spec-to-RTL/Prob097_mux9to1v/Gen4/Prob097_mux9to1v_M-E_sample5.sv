module TopModule(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [15:0] i,
    input [3:0] sel,
    output reg [15:0] out
);

reg [15:0] group_out;

always @(*)
begin
    case (sel[3:2])  // Select one of four groups
        2'd0: group_out = (sel[1:0] == 2'd0) ? a : b;
        2'd1: group_out = (sel[1:0] == 2'd0) ? c : d;
        2'd2: group_out = (sel[1:0] == 2'd0) ? e : f;
        default: group_out = (sel[1:0] == 2'd0) ? g : (sel[1:0] == 2'd1) ? h : i;
    endcase

    if (sel > 4'd8)  // For sel values 9 to 15, set all output bits to '1'
        out = 16'd65535;
    else
        out = group_out;
end

endmodule