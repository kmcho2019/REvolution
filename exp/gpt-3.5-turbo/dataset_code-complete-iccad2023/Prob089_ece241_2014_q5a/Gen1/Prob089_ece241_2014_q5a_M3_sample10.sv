module TopModule (
  input clk,
  input areset,
  input x,
  output reg [7:0] z
);

parameter IDLE = 2'b00;
parameter CONVERTING = 2'b01;

reg [1:0] state;
reg [7:0] complement_temp;
reg [2:0] counter;

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= IDLE;
    z <= 8'b0;
    counter <= 3'b000;
  end
  else begin
    case (state)
      IDLE: begin
        if (x) begin
          state <= CONVERTING;
          counter <= 3'b000;
        end
      end
      CONVERTING: begin
        case (counter)
          3'b000: begin // Calculate the 2's complement
            complement_temp <= (~x) + 1;
            z <= {complement_temp[0], z[7:1]};
          end
          3'b111: state <= IDLE;
          default: begin
            z <= {complement_temp[3-counter], z[7:1]};
          end
        endcase
        counter <= counter + 1;
      end
    endcase
  end
end

endmodule