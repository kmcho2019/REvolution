module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    reg [3:0] shift_reg;

    // Shift register implementation
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= 4'b0;
        end
        else begin
            shift_reg <= {shift_reg[2:0], data_in};
        end
    end

    // Parallel pattern matching
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sequence_detected <= 1'b0;
        end
        else begin
            sequence_detected <= (shift_reg == 4'b1001);
        end
    end

endmodule