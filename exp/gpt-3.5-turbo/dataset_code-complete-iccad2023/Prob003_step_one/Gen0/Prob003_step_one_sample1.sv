module TopModule (
  output reg one // Using 'reg' as it can be assigned in always block
);

initial begin
  one = 1'b1; // Assigning logic high value to the output
end

endmodule