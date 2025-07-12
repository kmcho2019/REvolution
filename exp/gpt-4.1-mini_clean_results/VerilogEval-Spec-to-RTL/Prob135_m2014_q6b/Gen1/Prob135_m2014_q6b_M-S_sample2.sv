module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    reg y1_next;

    always @* begin
        case (y)
            3'b000: y1_next = 1'b0;        // A(000): next y1=0 for both w=0 or 1
            3'b001: y1_next = 1'b1;        // B(001): next y1=1 for both w=0 or 1
            3'b010: y1_next = w ? 1'b1 : 1'b0; // C(010): w=0->E(100)y1=0, w=1->D(011)y1=1
            3'b011: y1_next = 1'b0;        // D(011): next y1=0 for both w=0 or 1
            3'b100: y1_next = w ? 1'b1 : 1'b0; // E(100): w=0->E(100)y1=0, w=1->D(011)y1=1
            3'b101: y1_next = 1'b1;        // F(101): next y1=1 for both w=0 or 1
            default: y1_next = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule