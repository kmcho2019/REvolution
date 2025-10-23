module sequence_detector #(
    parameter SEQUENCE_LENGTH = 4,
    parameter DESIRED_SEQUENCE = 4'b1001
)(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

reg [SEQUENCE_LENGTH-1:0] shift_register;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_register <= {SEQUENCE_LENGTH{1'b0}};
        sequence_detected <= 1'b0;
    end else begin
        shift_register <= {shift_register[SEQUENCE_LENGTH-2:0], data_in};
        sequence_detected <= (shift_register == DESIRED_SEQUENCE) ? 1'b1 : 1'b0;
    end
end

endmodule