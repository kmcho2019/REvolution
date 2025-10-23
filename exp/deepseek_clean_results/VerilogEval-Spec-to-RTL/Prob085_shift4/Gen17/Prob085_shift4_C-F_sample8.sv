module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;          // Highest priority: async reset
    end
    else begin
        if (load) begin     // Next priority: synchronous load
            q <= data;
        end
        else if (ena) begin // Then shift if enabled
            q <= {1'b0, q[3:1]};  // Efficient right shift
        end
        // else retain value (implicit)
    end
end

endmodule