module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // Shift register to store last three values of data_in

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Asynchronous reset
        shift_reg <= 3'b000;
        data_out <= 1'b0;
    end else begin
        shift_reg <= {data_in, shift_reg[2:1]}; // Shift in new data_in value
        if (shift_reg == 3'b010) begin // Check for pulse pattern
            data_out <= 1'b1;
        end else begin
            data_out <= 1'b0;
        end
    end
end

endmodule