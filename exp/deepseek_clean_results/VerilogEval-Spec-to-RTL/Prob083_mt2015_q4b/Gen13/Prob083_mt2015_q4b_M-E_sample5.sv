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
            2'b00: state = S00;
            2'b01: state = S01;
            2'b10: state = S10;
            2'b11: state = S11;
        endcase

        // Output is 1 when inputs match (XNOR behavior)
        z = (state == S00) || (state == S11);
    end

endmodule