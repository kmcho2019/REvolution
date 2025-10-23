module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] state;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    always @(*) begin
        case ({x,y})
            2'b00: begin
                z = 1'b1;
                state = S0;
            end
            2'b01: begin
                z = 1'b0;
                state = S1;
            end
            2'b10: begin
                z = 1'b0;
                state = S2;
            end
            2'b11: begin
                z = 1'b1;
                state = S3;
            end
        endcase
    end
endmodule