module TopModule (
  output reg zero // reg type is used to assign a constant value
);
  
  always @* begin
    zero = 0;
  end

endmodule