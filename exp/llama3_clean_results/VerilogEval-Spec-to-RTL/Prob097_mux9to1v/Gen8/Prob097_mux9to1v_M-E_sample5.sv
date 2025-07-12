module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

reg [15:0] selected_input;

always @(*)
begin
    case (sel)
        4'd0: selected_input = a;
        4'd1: selected_input = b;
        4'd2: selected_input = c;
        4'd3: selected_input = d;
        4'd4: selected_input = e;
        4'd5: selected_input = f;
        4'd6: selected_input = g;
        4'd7: selected_input = h;
        4'd8: selected_input = i;
        default: selected_input = 16'hFFFF;
    endcase
end

assign out = selected_input;

endmodule