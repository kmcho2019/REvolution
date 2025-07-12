module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg wrap;
wire increment = ~reset & ~wrap;

always @(posedge clk) begin
    wrap <= (q == 4'b1010);  // Registered wrap condition
    
    if (reset) begin
        q <= 4'b0001;        // Direct reset assignment
    end
    else if (wrap) begin
        q <= 4'b0001;        // Wrap around
    end
    else if (increment) begin
        q <= q + 1;          // Gated increment
    end
end

endmodule