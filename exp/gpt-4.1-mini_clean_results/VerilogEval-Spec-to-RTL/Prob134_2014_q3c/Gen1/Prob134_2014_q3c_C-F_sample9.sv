module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output reg   z
);

    reg [2:0] Y_next;

    always @(*) begin
        case (y)
            3'b000: begin
                if (x == 1'b0) Y_next = 3'b000;
                else           Y_next = 3'b001;
                z = 1'b0;
            end
            3'b001: begin
                if (x == 1'b0) Y_next = 3'b001;
                else           Y_next = 3'b100;
                z = 1'b0;
            end
            3'b010: begin
                if (x == 1'b0) Y_next = 3'b010;
                else           Y_next = 3'b001;
                z = 1'b0;
            end
            3'b011: begin
                if (x == 1'b0) Y_next = 3'b001;
                else           Y_next = 3'b010;
                z = 1'b1;
            end
            3'b100: begin
                if (x == 1'b0) Y_next = 3'b011;
                else           Y_next = 3'b100;
                z = 1'b1;
            end
            default: begin
                Y_next = 3'b000;
                z = 1'b0;
            end
        endcase
    end

    assign Y0 = Y_next[0];

endmodule