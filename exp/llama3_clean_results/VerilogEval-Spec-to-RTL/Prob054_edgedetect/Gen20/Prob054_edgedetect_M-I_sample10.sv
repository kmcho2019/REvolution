module EdgeDetect(
    input clk,
    input in,
    output reg pedge
);

reg prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    // Update prev_in only when in changes to reduce switching activity
    if (in!= prev_in) begin
        prev_in <= in;
    end
    
    // Detect 0 to 1 transition using a simple comparison
    pedge <= (in == 1'b1) && (prev_in == 1'b0);
end

endmodule

module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

// Using a generate block to instantiate EdgeDetect modules
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        EdgeDetect edge_detect(
           .clk(clk),
           .in(in[i]),
           .pedge(pedge[i])
        );
    end
endgenerate

endmodule