module TopModule (
  input clk,
  input areset,
  input load,
  input ena,
  input [3:0] data,
  output reg [3:0] q
);

  reg [3:0] reg_data;
  reg [1:0] state;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00; // IDLE state
      reg_data <= 4'b0000;
    end
    else begin
      case (state)
        2'b00: begin // IDLE state
          if (load)
            state <= 2'b10; // LOAD state
          else if (ena)
            state <= 2'b01; // SHIFT state
        end
        2'b01: begin // SHIFT state
          state <= 2'b00; // Back to IDLE state
        end
        2'b10: begin // LOAD state
          state <= 2'b00; // Back to IDLE state
        end
        default: state <= 2'b00; // Default to IDLE state
      endcase
    end
  end

  always @* begin
    case (state)
      2'b00: q = reg_data;
      2'b01: begin // SHIFT state
        reg_data[3:1] = reg_data[2:0];
        reg_data[0] = 1'b0;
        q = reg_data;
      end
      2'b10: begin // LOAD state
        reg_data = data;
        q = reg_data;
      end
      default: q = 4'bxxxx; // Default to 'X' if unknown state
    endcase
  end

endmodule