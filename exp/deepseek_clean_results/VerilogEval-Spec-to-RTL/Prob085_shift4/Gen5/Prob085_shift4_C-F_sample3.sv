module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Priority: areset > load > ena > maintain
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;          // Async reset (highest priority)
    end
    else if (load) begin
        q <= data;           // Sync load (priority over ena)
    end
    else if (ena) begin
        q <= {1'b0, q[3:1]}; // Sync right shift (MSB=0)
    end
    // else maintain current value
end

endmodule