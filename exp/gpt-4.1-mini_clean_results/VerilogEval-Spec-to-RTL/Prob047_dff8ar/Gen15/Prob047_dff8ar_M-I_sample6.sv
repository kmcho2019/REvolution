// Parameterized vector D flip-flop with asynchronous assertion and synchronous reset release
module DFF_Vector_AsyncAssertSyncRelease #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    reg async_rst_sync;

    // Asynchronous assertion of reset, synchronous deassertion
    always @(posedge clk or posedge areset) begin
        if (areset)
            async_rst_sync <= 1'b1;
        else
            async_rst_sync <= 1'b0;
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};  // async reset assert
        else if (async_rst_sync)
            q <= {WIDTH{1'b0}};  // sync reset release stage
        else
            q <= d;
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit vector DFF with improved async reset handling
    DFF_Vector_AsyncAssertSyncRelease #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule