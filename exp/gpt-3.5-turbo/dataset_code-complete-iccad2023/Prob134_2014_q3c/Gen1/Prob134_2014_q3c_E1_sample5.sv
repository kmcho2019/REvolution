module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// Define states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

// State transition logic for Y[0] and z
always @(*) begin
  case(y)
    S0: begin
        if (x == 1'b0) Y0 = 1'b0;
        else if (x == 1'b1) Y0 = 1'b0;
        z = 1'b0;
    end
    S1: begin
        if (x == 1'b0) Y0 = 1'b0;
        else if (x == 1'b1) Y0 = 1'b1;
        z = 1'b0;
    end
    S2: begin
        if (x == 1'b0) Y0 = 1'b0;
        else if (x == 1'b1) Y0 = 1'b0;
        z = 1'b0;
    end
    S3: begin
        if (x == 1'b0) Y0 = 1'b0;
        else if (x == 1'b1) Y0 = 1'b1;
        z = 1'b1;
    end
    S4: begin
        if (x == 1'b0) Y0 = 1'b1;
        else if (x == 1'b1) Y0 = 1'b0;
        z = 1'b1;
    end
    default: begin
        Y0 = 1'bx;
        z = 1'bx;
    end
  endcase
end

endmodule