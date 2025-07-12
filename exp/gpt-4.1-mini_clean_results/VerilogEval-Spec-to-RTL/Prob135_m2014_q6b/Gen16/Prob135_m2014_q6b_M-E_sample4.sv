module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Define state codes for clarity
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b100,
                     F = 3'b101;

    reg next_y1;

    always @(*) begin
        case (y)
            A: next_y1 = 1'b0;   // y=000 => y1=0 next state logic from transitions
            B: next_y1 = w ? 1'b1 : 1'b0; // B(001) --0--> C(010) y1=1; --1--> D(011) y1=1
            C: next_y1 = w ? 1'b1 : 1'b0; // C(010) --0--> E(100) y1=0; --1--> D(011) y1=1
            D: next_y1 = w ? 1'b1 : 1'b0; // D(011) --0--> F(101) y1=0; --1--> A(000) y1=0
            E: next_y1 = w ? 1'b1 : 1'b0; // E(100) stays E(100) y1=0 or D(011) y1=1
            F: next_y1 = w ? 1'b1 : 1'b0; // F(101) --0--> C(010) y1=1; --1--> D(011) y1=1
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = next_y1;

endmodule