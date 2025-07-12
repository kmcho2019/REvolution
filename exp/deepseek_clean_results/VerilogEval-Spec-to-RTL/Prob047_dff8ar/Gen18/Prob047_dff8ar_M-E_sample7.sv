module TopModule (
    input wire clk,
    input wire areset,
    input wire [7:0] d,
    output reg [7:0] q
);

// Define reset value as a parameter for flexibility
localparam RESET_VALUE = 8'b0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= RESET_VALUE;  // Vector reset in one operation
    end else begin
        q <= d;             // Vector assignment
    end
end

endmodule