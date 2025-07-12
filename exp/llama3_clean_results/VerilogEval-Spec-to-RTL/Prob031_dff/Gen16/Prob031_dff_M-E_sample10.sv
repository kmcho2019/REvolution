module TopModule(
    input clk,
    input d,
    output q
);

reg q_int;

assign q = q_int;

always @(posedge clk) begin
    q_int <= d;
end

// Alternatively, to implement a more traditional master-slave DFF:
// reg master, slave;
// always @(posedge clk) master <= d;
// always @(negedge clk) slave <= master;
// assign q = slave;

endmodule