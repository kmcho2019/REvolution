module TopModule (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [2:0]  y,   // current state (3 bits)
    input  wire        w,
    output wire        Y1
);

    // Next state signals for y
    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    reg y1_next;

    // Next state logic for y[1]
    always @(*) begin
        case (y)
            3'b000: y1_next = 1'b0; // A (000)
            3'b001: y1_next = (w == 1'b0) ? 1'b0 : 1'b1; // B (001)
            3'b010: y1_next = (w == 1'b0) ? 1'b1 : 1'b1; // C (010)
            3'b011: y1_next = (w == 1'b0) ? 1'b1 : 1'b0; // D (011)
            3'b100: y1_next = 1'b1;                       // E (100)
            3'b101: y1_next = 1'b1;                       // F (101)
            default: y1_next = 1'b0;
        endcase
    end

    assign Y1 = y[1];

endmodule