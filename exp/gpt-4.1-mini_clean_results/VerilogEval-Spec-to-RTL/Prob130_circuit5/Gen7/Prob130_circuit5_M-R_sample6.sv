module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Define an array with the five possible 4-bit values
    reg [3:0] data_array [0:4];

    always @* begin
        data_array[0] = b;
        data_array[1] = e;
        data_array[2] = a;
        data_array[3] = d;
        data_array[4] = 4'hF;
        case (c)
            4'd0: q = data_array[0];
            4'd1: q = data_array[1];
            4'd2: q = data_array[2];
            4'd3: q = data_array[3];
            default: q = data_array[4];
        endcase
    end

endmodule