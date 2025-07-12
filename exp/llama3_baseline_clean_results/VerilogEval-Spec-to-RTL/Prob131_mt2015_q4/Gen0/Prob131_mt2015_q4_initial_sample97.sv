module ModuleA(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

// Module B's logic based on the simulation waveform
module ModuleB(x, y, z);
  input x, y;
  output z;
  assign z = ~(x ^ y);
endmodule

module TopLevel(x, y, z);
  input x, y;
  output z;
  wire a1, b1, a2, b2;
  
  // Instantiating Module A and Module B
  ModuleA A1(x, y, a1);
  ModuleB B1(x, y, b1);
  ModuleA A2(x, y, a2);
  ModuleB B2(x, y, b2);
  
  // Connecting outputs to OR and AND gates
  wire or_out, and_out;
  assign or_out = a1 | b1;
  assign and_out = a2 & b2;
  
  // Final XOR gate to produce output 'z'
  assign z = or_out ^ and_out;
endmodule

// Testbench for verification
module testbench;
  reg x, y;
  wire z;
  
  TopLevel top(x, y, z);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    
    x = 0; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 1; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 1; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 1; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 1; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 1; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 0; y = 1; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    x = 1; y = 0; #10;
    $display("x = %b, y = %b, z = %b", x, y, z);
    
    $finish;
  end
endmodule