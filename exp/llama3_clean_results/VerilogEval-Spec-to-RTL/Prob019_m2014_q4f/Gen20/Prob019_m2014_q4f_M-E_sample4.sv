module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using a case statement to implement the truth table
always @(*) begin
    case ({in1, in2})
        2'b10: out = 1'b1; // in1=1, in2=0
        default: out = 1'b0;
    endcase
end

endmodule