module TopModule(
    input in,
    output reg out
);
    // Fixed select line to 0, so out = in
    wire sel = 1'b0;
    wire mux_out;

    assign mux_out = (sel == 1'b0) ? in : 1'b0;

    always @(*) begin
        out = mux_out;
    end
endmodule