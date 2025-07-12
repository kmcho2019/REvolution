module TopModule(
    input clk,
    input d,
    output q
);

reg qReg;
reg prevClk;

always @(posedge clk) begin
    prevClk <= clk;
    qReg <= d;
end

always @(negedge clk) begin
    qReg <= d;
end

assign q = qReg;

// To maintain the output on both edges, 
// an additional always block can be used to hold the output stable
always @(posedge clk or negedge clk) begin
    if (prevClk == 1'b0 && clk == 1'b1) begin // Rising edge
        qReg <= d;
    end else if (prevClk == 1'b1 && clk == 1'b0) begin // Falling edge
        qReg <= d;
    end
end

endmodule