module TopModule(
    input  in1,
    input  in2,
    output out
);

// Implementing NOR gate using a multiplexer
wire not_in1, not_in2;
assign not_in1 = ~in1;
assign not_in2 = ~in2;

// Using a MUX to implement the NOR logic
assign out = (in1 == 1'b0 && in2 == 1'b0) ? 1'b1 :
             (in1 == 1'b0 && in2 == 1'b1) ? 1'b0 :
             (in1 == 1'b1 && in2 == 1'b0) ? 1'b0 :
             (in1 == 1'b1 && in2 == 1'b1) ? 1'b0 : 1'b0;

// Alternatively, using the mux logic more directly
// assign out = (in1 & in2) ? 1'b0 : ((~in1 & ~in2) ? 1'b1 : 1'b0);

endmodule