module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input a,
    output q
);
    // Pass inverted 'a' directly to DFF input to minimize logic within DFF
    DFF dff_inst (
        .clk(clk),
        .d(~a),
        .q(q)
    );
endmodule