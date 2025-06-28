module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg [1:0] counter;

  always @(posedge clock) begin
    if (a) begin
      counter <= 2'b00;
    end
    else begin
      case(counter)
        2'b00: begin // State 0
          counter <= 2'b01;
        end
        
        2'b01: begin // State 1
          counter <= 2'b10;
        end
        
        2'b10: begin // State 2
          counter <= 2'b00;
        end
      endcase
    end
  end

  // Outputs based on counter value
  always @* begin
    case(counter)
      2'b00: begin // State 0
        p = 0; q = 0;
      end
      
      2'b01: begin // State 1
        p = 0; q = 1;
      end
      
      2'b10: begin // State 2
        p = 1; q = 0;
      end
    endcase
  end
endmodule