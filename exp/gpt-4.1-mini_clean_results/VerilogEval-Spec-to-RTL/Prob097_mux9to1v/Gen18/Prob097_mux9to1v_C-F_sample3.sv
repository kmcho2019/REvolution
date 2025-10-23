module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

    // Pack inputs into an array for indexed access
    wire [15:0] inputs_arr [0:8];
    assign inputs_arr[0] = a;
    assign inputs_arr[1] = b;
    assign inputs_arr[2] = c;
    assign inputs_arr[3] = d;
    assign inputs_arr[4] = e;
    assign inputs_arr[5] = f;
    assign inputs_arr[6] = g;
    assign inputs_arr[7] = h;
    assign inputs_arr[8] = i;

    always @(*) begin
        case (sel)
            4'd0: out = inputs_arr[0];
            4'd1: out = inputs_arr[1];
            4'd2: out = inputs_arr[2];
            4'd3: out = inputs_arr[3];
            4'd4: out = inputs_arr[4];
            4'd5: out = inputs_arr[5];
            4'd6: out = inputs_arr[6];
            4'd7: out = inputs_arr[7];
            4'd8: out = inputs_arr[8];
            default: out = 16'hFFFF; // For sel=9 to 15
        endcase
    end

endmodule