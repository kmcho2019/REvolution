module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [2:0] shift_reg; // Hold the last three samples of data_in

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 3'b000;
            data_out <= 1'b0;
        end else begin
            // Shift in current data_in
            shift_reg <= {shift_reg[1:0], data_in};

            // Detect the pattern 0 -> 1 -> 0 over last three cycles
            // That means shift_reg == 3'b010, where shift_reg[2] = oldest, [0] = newest
            if (shift_reg == 3'b010)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule