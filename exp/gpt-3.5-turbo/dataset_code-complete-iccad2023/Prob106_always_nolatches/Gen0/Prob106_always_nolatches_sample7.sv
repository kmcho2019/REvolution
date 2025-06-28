module TopModule (
  input [15:0] scancode,
  output reg left,
  output reg down,
  output reg right,
  output reg up
);

always @(*)
begin
  case(scancode[15:8])
    8'h0E:
      begin
        if(scancode[7:0] == 8'h06B)
        begin
          left = 1;
          down = 0;
          right = 0;
          up = 0;
        end
        else if(scancode[7:0] == 8'h075)
        begin
          left = 0;
          down = 0;
          right = 0;
          up = 1;
        end
        else
        begin
          left = 0;
          down = 0;
          right = 0;
          up = 0;
        end
      end
    8'h0F:
      begin
        if(scancode[7:0] == 8'h072)
        begin
          left = 0;
          down = 1;
          right = 0;
          up = 0;
        end
        else
        begin
          left = 0;
          down = 0;
          right = 0;
          up = 0;
        end
      end
    8'h1C:
      begin
        if(scancode[7:0] == 8'h074)
        begin
          left = 0;
          down = 0;
          right = 1;
          up = 0;
        end
        else
        begin
          left = 0;
          down = 0;
          right = 0;
          up = 0;
        end
      end
    default:
      begin
        left = 0;
        down = 0;
        right = 0;
        up = 0;
      end
  endcase
end

endmodule