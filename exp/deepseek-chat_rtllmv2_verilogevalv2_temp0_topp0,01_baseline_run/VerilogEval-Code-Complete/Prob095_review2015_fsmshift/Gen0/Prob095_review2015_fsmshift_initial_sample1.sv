module TopModule (
  input clk,
  input reset,
  output reg shift_ena
);

  reg [1:0] counter;
  reg state;

  localparam SHIFT_ENABLED = 1'b0;
  localparam SHIFT_DISABLED = 1'b1;

  always @(posedge clk) begin
    if (reset) begin
      state <= SHIFT_ENABLED;
      counter <= 2'b11; // Counts 3,2,1,0 (4 cycles)
      shift_ena <= 1'b1;
    end else begin
      case (state)
        SHIFT_ENABLED: begin
          if (counter == 2'b00) begin
            state <= SHIFT_DISABLED;
            shift_ena <= 1'b0;
          end else begin
            counter <= counter - 1;
          end
        end
        SHIFT_DISABLED: begin
          shift_ena <= 1'b0;
        end
      endcase
    end
  end

endmodule