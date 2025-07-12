module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Vector of inputs indexed by c[1:0]: 0=b,1=e,2=a,3=d
    wire [3:0] vector [3:0];
    assign vector[0] = b;
    assign vector[1] = e;
    assign vector[2] = a;
    assign vector[3] = d;

    always @* begin
        if (c < 4)
            case (c[1:0])
                2'd0: q = vector[0];
                2'd1: q = vector[1];
                2'd2: q = vector[2];
                2'd3: q = vector[3];
                default: q = 4'hF; // Should never happen since c<4
            endcase
        else
            q = 4'hF;
    end

endmodule