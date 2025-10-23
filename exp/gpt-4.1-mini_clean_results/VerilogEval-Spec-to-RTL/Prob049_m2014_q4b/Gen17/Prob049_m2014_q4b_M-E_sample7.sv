module TopModule (
    input  clk,
    input  ar,    // asynchronous active-high reset
    input  d,
    output reg q
);

    wire d_mux;

    // Multiplex input to zero when asynchronous reset asserted
    assign d_mux = ar ? 1'b0 : d;

    always @(posedge clk or posedge ar) begin
        if (ar)
            q <= 1'b0; // async reset path
        else
            q <= d_mux; // latch data when no reset
    end

endmodule