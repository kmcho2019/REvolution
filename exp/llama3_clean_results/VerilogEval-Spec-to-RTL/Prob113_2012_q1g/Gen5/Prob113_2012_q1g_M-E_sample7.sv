module TopModule(
    input [3:0] x,
    output f
);

    always @(x) begin
        case ({x[2], x[3]})
            2'b00: f = (x[0] == 0 && x[1] == 0) || (x[0] == 1 && x[1] == 0);
            2'b01: f = 0;
            2'b11: f = (x[0] == 0 && x[1] == 0) || (x[0] == 0 && x[1] == 1) || (x[0] == 1 && x[1] == 1);
            2'b10: f = (x[0] == 0 && x[1] == 0) || (x[0] == 0 && x[1] == 1) || (x[0] == 1 && x[1] == 0);
            default: f = 0;
        endcase
    end

endmodule