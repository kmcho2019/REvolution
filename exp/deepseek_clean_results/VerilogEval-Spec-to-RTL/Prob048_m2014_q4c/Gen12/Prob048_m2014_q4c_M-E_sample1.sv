module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

localparam RESET_STATE = 1'b0;

always @(posedge clk) begin
    case (r)
        1'b1: q <= RESET_STATE;  // Synchronous reset
        1'b0: q <= d;           // Normal operation
        default: q <= RESET_STATE; // Handle x/z cases (synthesis will optimize this)
    endcase
end

endmodule