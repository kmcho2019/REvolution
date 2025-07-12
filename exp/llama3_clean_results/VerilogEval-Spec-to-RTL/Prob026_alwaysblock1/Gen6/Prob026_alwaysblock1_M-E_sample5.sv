module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Assign statement for instantaneous output
assign out_assign = a & b;

// Parameterizable delay for the always block
parameter DELAY = 1; // default delay is 1 clock cycle

reg out_alwaysblock_reg;
integer delay_counter;

always @(*) begin
    out_alwaysblock_reg = a & b;
end

always @(posedge a or posedge b) begin
    delay_counter = 0;
    out_alwaysblock = 1'b0;
end

always @(posedge a or posedge b) begin
    if (delay_counter < DELAY) begin
        delay_counter = delay_counter + 1;
    end else begin
        out_alwaysblock = out_alwaysblock_reg;
    end
end

endmodule