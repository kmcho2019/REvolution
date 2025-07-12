module TopModule(output reg one);
  // Asynchronous set to '1' drives output high immediately at reset/startup
  always @(posedge 1'b0 or posedge 1'b1) begin
    if (1'b1) 
      one <= 1'b1; // set output to 1 asynchronously
  end
endmodule