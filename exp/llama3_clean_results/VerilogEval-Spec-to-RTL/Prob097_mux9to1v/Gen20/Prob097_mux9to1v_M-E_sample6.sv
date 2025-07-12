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
    output reg [15:0] out
);

reg [15:0] data[8:0];

always @(*) begin
    // Assign inputs to data array
    data[0] = a;
    data[1] = b;
    data[2] = c;
    data[3] = d;
    data[4] = e;
    data[5] = f;
    data[6] = g;
    data[7] = h;
    data[8] = i;

    // Use decoder to select input
    case (sel)
        4'd0: out = data[0];
        4'd1: out = data[1];
        4'd2: out = data[2];
        4'd3: out = data[3];
        4'd4: out = data[4];
        4'd5: out = data[5];
        4'd6: out = data[6];
        4'd7: out = data[7];
        4'd8: out = data[8];
        default: out = {16{1'b1}};
    endcase
end

endmodule