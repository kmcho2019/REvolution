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

    // Pack inputs into an array for clean indexed access
    wire [15:0] inputs_arr [0:8];

    // Use generate block for scalable clean assignments
    genvar idx;
    generate
        for (idx = 0; idx < 9; idx = idx + 1) begin : input_assign
            // Assign inputs according to index
            if (idx == 0) assign inputs_arr[idx] = a;
            else if (idx == 1) assign inputs_arr[idx] = b;
            else if (idx == 2) assign inputs_arr[idx] = c;
            else if (idx == 3) assign inputs_arr[idx] = d;
            else if (idx == 4) assign inputs_arr[idx] = e;
            else if (idx == 5) assign inputs_arr[idx] = f;
            else if (idx == 6) assign inputs_arr[idx] = g;
            else if (idx == 7) assign inputs_arr[idx] = h;
            else if (idx == 8) assign inputs_arr[idx] = i;
        end
    endgenerate

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
            default: out = 16'hFFFF; // sel 9 to 15 and defensive default
        endcase
    end

endmodule