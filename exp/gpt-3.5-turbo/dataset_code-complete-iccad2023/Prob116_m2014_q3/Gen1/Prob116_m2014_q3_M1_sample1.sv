module TopModule (
  input [4:1] x,
  output logic f
);

assign f = (x[1] & x[2]) |                      // group: 01, 11
            (x[1] & x[3]) |                      // group: 11
            (x[2] & x[4]) |                      // group: 10
            (x[3] & x[4]) |                      // group: 01, 11
            (~x[1] & ~x[2] & ~x[4]) |            // d = 1
            (~x[2] & ~x[3] & x[4]) |             // d = 1
            (~x[1] & x[2] & ~x[3]) |             // d = 1
            (~x[1] & ~x[3] & ~x[4]);             // d = 0

endmodule