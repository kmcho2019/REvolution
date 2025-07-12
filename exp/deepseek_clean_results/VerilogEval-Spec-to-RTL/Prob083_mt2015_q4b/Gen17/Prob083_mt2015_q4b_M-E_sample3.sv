module TopModule (
    input x,
    input y,
    output reg z
);
    // State encoding
    localparam S00 = 2'b00;
    localparam S01 = 2'b01;
    localparam S10 = 2'b10;
    localparam S11 = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    // State transition logic
    always @(*) begin
        case ({x, y})
            2'b00: next_state = S00;
            2'b01: next_state = S01;
            2'b10: next_state = S10;
            2'b11: next_state = S11;
            default: next_state = S00;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            S00: z = 1'b1;
            S01: z = 1'b0;
            S10: z = 1'b0;
            S11: z = 1'b1;
            default: z = 1'b1;
        endcase
    end

    // State register (though not really needed for combinational logic)
    always @(*) begin
        current_state = next_state;
    end
endmodule