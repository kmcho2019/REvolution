module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational logic for next state
assign next_q = areset ? 4'b0 :        // Highest priority: async reset
                load ? data :          // Next priority: load
                ena ? {1'b0, q[3:1]} : // Then shift if enabled
                q;                     // Else retain value

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end
    else begin
        q <= next_q;
    end
end

endmodule