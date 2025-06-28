module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Parameters
parameter START_BIT = 1'b0;
parameter STOP_BIT = 1'b1;
parameter DATA_BIT_COUNT = 8;

// Registers
reg [7:0] shift_reg = 8'hFF; // Initialize shift register with all 1's
reg [3:0] bit_count = 4'b0000;
reg receiving_byte = 1'b0;

// FSM
always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 8'hFF;
        bit_count <= 4'b0000;
        receiving_byte <= 1'b0;
        done <= 0;
    end
    else begin
        shift_reg <= {shift_reg[6:0], in}; // Shift in new bit

        if (!receiving_byte && shift_reg[0] == START_BIT) begin
            bit_count <= 1;
            receiving_byte <= 1;
        end
        else if (receiving_byte && bit_count < DATA_BIT_COUNT) begin
            bit_count <= bit_count + 1;
        end
        else if (receiving_byte && bit_count == DATA_BIT_COUNT && shift_reg[0] == STOP_BIT) begin
            receiving_byte <= 0;
            done <= 1;
        end
        else if (receiving_byte && bit_count == DATA_BIT_COUNT && shift_reg[0] != STOP_BIT) begin
            bit_count <= 0; // Restart receiving new byte
        end
    end
end

endmodule