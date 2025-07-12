module TopModule(
  input  clk,
  input  areset,
  input  x,
  output z
);

  reg [1:0] state;
  reg [1:0] next_state;
  
  // State encoding: A = 2'b01, B = 2'b10

  always @(posedge clk or posedge areset)
    if(areset)
      state <= 2'b01; // reset to state A
    else
      state <= next_state;

  always @(*)
  begin
    case(state)
      2'b01: // state A
      begin
        if(x == 0)
        begin
          next_state = 2'b01; // stay in A
          z = 1'b0;
        end
        else
        begin
          next_state = 2'b10; // transition to B
          z = 1'b1;
        end
      end
      2'b10: // state B
      begin
        if(x == 0)
        begin
          next_state = 2'b10; // stay in B
          z = 1'b1;
        end
        else
        begin
          next_state = 2'b10; // stay in B
          z = 1'b0;
        end
      end
      default:
      begin
        next_state = 2'b01; // default state A
        z = 1'b0;
      end
    endcase
  end

endmodule