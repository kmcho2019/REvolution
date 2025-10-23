module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    reg [3:0] shift_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= 4'b0000;
            sequence_detected <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data_in};
            sequence_detected <= (shift_reg == 4'b1001);
        end
    end

endmodule