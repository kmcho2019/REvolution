module TopModule (
    output one
);
    localparam ALWAYS_HIGH = 1'b1;
    assign one = ALWAYS_HIGH;
endmodule