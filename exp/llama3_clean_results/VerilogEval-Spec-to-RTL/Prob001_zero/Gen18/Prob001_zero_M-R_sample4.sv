module TopModule(
    output zero
);
    always @(/* no sensitivity list */) begin
        zero = 0;
    end
endmodule