module TopModule (
    input        clk,    // Added clock input
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out // Registered output
);

    always @(posedge clk) begin
        out <= sel ? b : a;  // Synchronous mux
    end

endmodule