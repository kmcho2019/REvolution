// Parameterized vector D flip-flop with asynchronous active-high reset and clock enable
module DFF_Vector_AsyncReset_Enable #(parameter WIDTH = 8) (
    input  wire             clk,
    input  wire             areset,    // Asynchronous active-high reset
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    // Enable signal: load data only if it differs from current output
    wire en = (d != q);

    // Asynchronous reset and clocked load with enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};    // Reset output vector to zero asynchronously
        else if (en)
            q <= d;                // Load new data only when changed
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);
    // Instantiate 8-bit DFF vector with async reset and enable for power optimization
    DFF_Vector_AsyncReset_Enable #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule