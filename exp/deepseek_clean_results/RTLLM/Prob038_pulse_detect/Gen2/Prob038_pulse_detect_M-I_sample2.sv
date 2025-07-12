module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] shift_reg;
reg last_data_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
        data_out <= 1'b0;
        last_data_in <= 1'b0;
    end
    else begin
        // Only update shift register when input changes
        last_data_in <= data_in;
        if (data_in != last_data_in) begin
            shift_reg <= {shift_reg[0], data_in};
        end
        
        // Registered detection logic
        data_out <= (shift_reg == 2'b10) && !data_in;
    end
end

endmodule