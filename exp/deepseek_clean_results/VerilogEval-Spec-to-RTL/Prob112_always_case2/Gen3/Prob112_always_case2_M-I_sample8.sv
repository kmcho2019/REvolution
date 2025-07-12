module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    if (in == 4'b0000) begin
        pos = 2'b00;  // Early exit for all-zero case
    end
    else begin
        casez (in)  // Priority encoder using casez
            4'b0001: pos = 2'b00;
            4'b001?: pos = 2'b01;
            4'b01??: pos = 2'b10;
            4'b1???: pos = 2'b11;
            default: pos = 2'b00;  // Should never reach here
        endcase
    end
end

endmodule