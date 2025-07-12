module DFF_Vector_AsyncReset #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,    // Asynchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Intermediate reset signal: synchronous reset generated asynchronously
    reg async_reset;

    // Combinational block to propagate asynchronous reset immediately
    always @(*) begin
        if (areset)
            async_reset = 1'b1;
        else
            async_reset = 1'b0;
    end

    // Synchronous process that triggers on clk only
    always @(posedge clk) begin
        if (async_reset)
            q <= {WIDTH{1'b0}};    // Reset output vector to zero
        else
            q <= d;                // On clock edge, latch input data
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit DFF vector with asynchronous reset implemented differently
    DFF_Vector_AsyncReset #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule