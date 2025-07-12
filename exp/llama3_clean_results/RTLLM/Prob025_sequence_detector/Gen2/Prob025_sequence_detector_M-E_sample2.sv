module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

parameter SEQUENCE_LENGTH = 4;
parameter TARGET_SEQUENCE = 4'b1001;

reg [SEQUENCE_LENGTH-1:0] shift_register;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_register <= 0;
        sequence_detected <= 0;
    end else begin
        shift_register <= {shift_register[SEQUENCE_LENGTH-2:0], data_in};
        
        if (shift_register == TARGET_SEQUENCE) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule