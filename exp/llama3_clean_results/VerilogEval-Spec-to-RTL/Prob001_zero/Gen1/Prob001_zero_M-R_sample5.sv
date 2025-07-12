module TopModule(
    output zero
);

always @(posedge zero) begin // Note: Using posedge zero here will not affect functionality since zero is always 0
    zero <= 1'b0;
end

initial begin
    zero = 1'b0;
end

endmodule