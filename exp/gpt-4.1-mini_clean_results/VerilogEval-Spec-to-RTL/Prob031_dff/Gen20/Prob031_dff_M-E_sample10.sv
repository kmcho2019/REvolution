module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Internal asynchronous reset signal tied inactive (no reset)
    wire reset_n = 1'b1; 

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            q <= 1'b0;      // Async reset inactive here, but allows easy extension later
        else
            q <= d;
    end
endmodule