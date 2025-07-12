module TopModule (
    input clk,
    input d,
    output q
);

// Custom DFF primitive with enable
DFF_PRIMITIVE dff_inst (
    .clk(clk),
    .d(d),
    .en(1'b1),  // Always enabled in this implementation
    .q(q_int)
);

// Output buffer for clean signal isolation
assign q = q_int;

endmodule

// Custom DFF primitive definition
module DFF_PRIMITIVE (
    input clk,
    input d,
    input en,
    output reg q
);
always @(posedge clk) begin
    if (en) begin
        q <= d;
    end
end
endmodule