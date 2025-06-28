module TopModule (
  input [5:0] y,
  input w,
  output reg Y1,
  output reg Y3
);

// Determine the next state based on the current state and input w
always @*
begin
  case(y)
    6'b000001: // A
      begin
        if(w) // A (0) --1--> B
          Y1 = 1;
        else // A (0) --0--> A
          Y1 = 0;
        Y3 = 0;
      end
    6'b000010: // B
      begin
        if(w) // B (0) --1--> C
          Y1 = 0;
        else // B (0) --0--> D
          Y1 = 1;
        Y3 = 0;
      end
    6'b000100: // C
      begin
        if(w) // C (0) --1--> E
          Y1 = 0;
        else // C (0) --0--> D
          Y1 = 1;
        Y3 = 1;
      end
    6'b001000: // D
      begin
        if(w) // D (0) --1--> F
          Y1 = 1;
        else // D (0) --0--> A
          Y1 = 0;
        Y3 = 0;
      end
    6'b010000: // E
      begin
        if(w) // E (1) --1--> E
          Y1 = 0;
        else // E (1) --0--> D
          Y1 = 1;
        Y3 = 0;
      end
    6'b100000: // F
      begin
        if(w) // F (1) --1--> C
          Y1 = 0;
        else // F (1) --0--> D
          Y1 = 1;
        Y3 = 1;
      end
    default:
      begin
        Y1 = 0; // Default value
        Y3 = 0; // Default value
      end
  endcase
end

endmodule