module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_int; // Internal flip-flop output

// Dual-edge triggered flip-flop implementation using a single flip-flop
always @(posedge clk or negedge clk) begin
    if (clk) begin
        q_int <= d;
    end else begin
        q_int <= d;
    end
end

// Output assignment
assign q = q_int;

endmodule