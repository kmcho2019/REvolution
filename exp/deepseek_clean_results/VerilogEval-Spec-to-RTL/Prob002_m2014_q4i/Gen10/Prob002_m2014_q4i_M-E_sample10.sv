module TopModule(output out);
    wire feedback;
    assign out = 1'b0 & feedback;
    assign feedback = out;
endmodule