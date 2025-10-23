module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Group control signals for better synthesis optimization
wire [1:0] ctrl = {load, ena};

always @(posedge clk or posedge areset) begin
    // Async reset (highest priority)
    if (areset) begin
        q <= 4'b0;
    end
    // Sync operations
    else begin
        casez (ctrl)
            2'b1?: q <= data;    // Load has priority
            2'b01: q <= {1'b0, q[3:1]};  // Shift right
            default: q <= q;      // Maintain value
        endcase
    end
end

endmodule