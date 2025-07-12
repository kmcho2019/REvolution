module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] state;

    always @(*) begin
        case({x,y})
            2'b00: z = 1'b1;
            2'b01: z = 1'b0;
            2'b10: z = 1'b0;
            2'b11: z = 1'b1;
            default: z = 1'b1;
        endcase
    end

    // State tracking (though not strictly needed for this function)
    always @(*) begin
        state = {x,y};
    end
endmodule