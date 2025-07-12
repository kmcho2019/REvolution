module TopModule(
    input  [3:0] x,
    output       f
);

    reg [1:0] x_high;
    reg [1:0] x_low;
    reg f_temp;

    assign x_high = {x[2], x[3]};
    assign x_low = {x[1], x[0]};

    always @(*) begin
        case(x_high)
            2'b00: f_temp = (x_low == 2'b00 || x_low == 2'b10);
            2'b01: f_temp = 1'b0;
            2'b10: f_temp = (x_low == 2'b00 || x_low == 2'b01 || x_low == 2'b10);
            2'b11: f_temp = (x_low == 2'b00 || x_low == 2'b01 || x_low == 2'b11);
            default: f_temp = 1'b0;
        endcase
    end

    assign f = f_temp;

endmodule