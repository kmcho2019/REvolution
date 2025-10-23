module TopModule (
    input clk,
    input a,
    output reg q
);

    wire a_inv;

    // Combinational inversion of input 'a'
    assign a_inv = ~a;

    // Sequential logic: register the inverted input at positive clock edge
    always @(posedge clk) begin
        q <= a_inv;
    end

endmodule