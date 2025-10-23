module TopModule (
    input x,
    input y,
    output reg z
);

    // Define states
    localparam S00 = 2'b00;
    localparam S01 = 2'b01;
    localparam S10 = 2'b10;
    localparam S11 = 2'b11;

    reg [1:0] state;

    always @(*) begin
        case ({x,y})
            2'b00: begin
                state = S00;
                z = 1'b1;
            end
            2'b01: begin
                state = S01;
                z = 1'b0;
            end
            2'b10: begin
                state = S10;
                z = 1'b0;
            end
            2'b11: begin
                state = S11;
                z = 1'b1;
            end
        endcase
    end

endmodule