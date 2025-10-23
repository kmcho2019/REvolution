module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Next state logic
wire [1:0] operation;
assign operation = areset ? 2'b00 :       // Reset has highest priority
                   load   ? 2'b01 :       // Load has priority over ena
                   ena    ? 2'b10 :       // Shift when enabled
                            2'b11;       // Otherwise hold

// Register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        case (operation)
            2'b01: q <= data;          // Load
            2'b10: q <= {1'b0, q[3:1]}; // Shift right
            default: q <= q;          // Hold (including reset case)
        endcase
    end
end

endmodule