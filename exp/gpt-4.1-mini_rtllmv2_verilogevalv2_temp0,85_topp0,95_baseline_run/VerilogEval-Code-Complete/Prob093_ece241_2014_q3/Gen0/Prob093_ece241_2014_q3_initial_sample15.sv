module TopModule (
  input c,
  input d,
  output [3:0] mux_in
);
  // Implement mux_in[0] = f0(c,d) with truth table:
  // cd: 00=0, 01=1, 11=1, 10=1
  // f0(c=0,d=0)=0
  // f0(c=0,d=1)=1
  // f0(c=1,d=1)=1
  // f0(c=1,d=0)=1
  // Implement f0 = d ? 1 : c ? 1 : 0 = d OR c
  wire f0_c0; // f0 when d=0
  wire f0_c1; // f0 when d=1
  // For d=0, f0 = c ? 1 : 0
  // For d=1, f0=1
  // Using 2-to-1 mux with c as selector:
  // if c=0 => 0
  // if c=1 => 1
  // This can be implemented as c
  // Then for d, mux selects between f0_c0 and f0_c1
  // f0_c0 = c
  // f0_c1 = 1
  // So f0 = d ? 1 : c
  // Implement 2-to-1 mux with selector d
  wire f0_mid;
  assign f0_mid = c; // when d=0
  assign mux_in[0] = d ? 1'b1 : f0_mid;

  // mux_in[1] = f1(c,d) = all zeros
  assign mux_in[1] = 1'b0;

  // mux_in[2] = f2(c,d):
  // cd: 00=0, 01=0, 11=1, 10=0
  // f2(0,0)=0
  // f2(0,1)=0
  // f2(1,1)=1
  // f2(1,0)=0
  // Implement f2 = d ? c : 0
  // For d=0, output 0
  // For d=1, output c
  assign mux_in[2] = d ? c : 1'b0;

  // mux_in[3] = f3(c,d):
  // cd: 00=1, 01=0, 11=1, 10=1
  // f3(0,0)=1
  // f3(0,1)=0
  // f3(1,1)=1
  // f3(1,0)=1
  // Let's rewrite f3 as:
  // For d=0: f3 = c ? 1 : 1 = 1
  // For d=1: f3 = c ? 1 : 0 = c
  // So f3 = d ? c : 1
  assign mux_in[3] = d ? c : 1'b1;

endmodule