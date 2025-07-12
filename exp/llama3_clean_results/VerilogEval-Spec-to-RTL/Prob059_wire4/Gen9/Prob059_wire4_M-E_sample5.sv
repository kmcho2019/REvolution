module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    reg [1:0] control;
    assign control = 2'b00; // Fixed routing

    always @(*) begin
        case (control)
            2'b00: begin
                w = a;
                x = b;
                y = b;
                z = c;
            end
            default: begin
                w = 1'b0;
                x = 1'b0;
                y = 1'b0;
                z = 1'b0;
            end
        endcase
    end
endmodule