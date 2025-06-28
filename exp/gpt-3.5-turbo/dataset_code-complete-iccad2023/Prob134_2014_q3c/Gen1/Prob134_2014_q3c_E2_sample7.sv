module TopModule (
  input x,
  input [2:0] y,
  output reg [2:0] Y,
  output reg Y0,
  output reg z
);

always @* begin
  case(y)
    3'b000:
      begin
        if (x == 1) begin
          Y = 3'b001;
          Y0 = 1'b0;
          z = 1'b0;
        end
        else begin
          Y = 3'b000;
          Y0 = 1'b0;
          z = 1'b0;
        end
      end

    3'b001:
      begin
        if (x == 1) begin
          Y = 3'b100;
          Y0 = 1'b0;
          z = 1'b0;
        end
        else begin
          Y = 3'b001;
          Y0 = 1'b0;
          z = 1'b0;
        end
      end

    3'b010:
      begin
        if (x == 1) begin
          Y = 3'b001;
          Y0 = 1'b0;
          z = 1'b0;
        end
        else begin
          Y = 3'b010;
          Y0 = 1'b0;
          z = 1'b0;
        end
      end

    3'b011:
      begin
        if (x == 1) begin
          Y = 3'b010;
          Y0 = 1'b1;
          z = 1'b1;
        end
        else begin
          Y = 3'b001;
          Y0 = 1'b0;
          z = 1'b0;
        end
      end

    3'b100:
      begin
        if (x == 1) begin
          Y = 3'b100;
          Y0 = 1'b1;
          z = 1'b1;
        end
        else begin
          Y = 3'b011;
          Y0 = 1'b0;
          z = 1'b0;
        end
      end
  endcase
end

endmodule