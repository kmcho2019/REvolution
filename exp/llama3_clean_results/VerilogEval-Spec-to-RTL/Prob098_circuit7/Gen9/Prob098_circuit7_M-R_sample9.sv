module TopModule(
    input clk,
    input a,
    output reg q
);

// Combinational logic to invert input a
wire inverted_a;
assign inverted_a = ~a;

// Sequential logic to update q at positive clock edge
always @(posedge clk) begin
    // Update q with the inverted value of a
    q <= inverted_a;
end

endmodule