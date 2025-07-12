module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

parameter SEQUENCE_LENGTH = 5;
parameter DESIRED_SEQUENCE = 5'b10011;

reg [SEQUENCE_LENGTH-1:0] shift_register;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        shift_register <= {SEQUENCE_LENGTH{1'b0}};
        MATCH <= 1'b0;
    end else begin
        shift_register <= {shift_register[SEQUENCE_LENGTH-:0], IN};
        if (shift_register == DESIRED_SEQUENCE) begin
            MATCH <= 1'b1;
        end else begin
            MATCH <= 1'b0;
        end
    end
end

endmodule