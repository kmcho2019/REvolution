module TopModule (
    output zero
);
always @(/* no sensitivity list needed for constant assignment */) begin
    zero = 1'b0;
end
endmodule