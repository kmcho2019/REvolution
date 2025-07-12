module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Combinational output logic
assign q = a ^ (b | state);

// State register updated on positive clock edge
always @(posedge clk) begin
    state <= q;
end

endmodule