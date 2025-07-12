module TopModule(
    output out
);

always @(/* no sensitivity list */) begin
    out = 1'b0;
end

endmodule