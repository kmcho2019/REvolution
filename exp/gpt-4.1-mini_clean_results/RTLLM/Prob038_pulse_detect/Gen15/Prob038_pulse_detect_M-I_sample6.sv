module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [2:0] shift_reg;
    reg       data_in_d; // delayed version of data_in for change detection

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 3'b000;
            data_out  <= 1'b0;
            data_in_d <= 1'b0;
        end else begin
            data_out <= 1'b0; // default

            if (data_in != data_in_d) begin
                // Shift in new data_in only when it changes to reduce toggling
                shift_reg <= {shift_reg[1:0], data_in};
            end

            data_in_d <= data_in;

            // Check pattern after shifting
            if (shift_reg == 3'b010) begin
                data_out <= 1'b1;
            end
        end
    end

endmodule