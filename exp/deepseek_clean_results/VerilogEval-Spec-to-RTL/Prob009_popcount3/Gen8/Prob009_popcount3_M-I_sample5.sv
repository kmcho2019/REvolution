module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Population count using explicit case statement
    reg [1:0] pop_count;
    always @(*) begin
        case (in)
            3'b000: pop_count = 2'b00;
            3'b001: pop_count = 2'b01;
            3'b010: pop_count = 2'b01;
            3'b011: pop_count = 2'b10;
            3'b100: pop_count = 2'b01;
            3'b101: pop_count = 2'b10;
            3'b110: pop_count = 2'b10;
            3'b111: pop_count = 2'b11;
            default: pop_count = 2'b00;
        endcase
    end
    assign out = pop_count;

endmodule