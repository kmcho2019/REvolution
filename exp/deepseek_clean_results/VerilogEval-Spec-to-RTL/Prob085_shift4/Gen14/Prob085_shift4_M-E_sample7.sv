module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;
reg [1:0] operation;

// Operation encoding:
// 00 - hold
// 01 - shift
// 10 - load
// 11 - reset (handled separately)

always @(*) begin
    case ({load, ena})
        2'b10: operation = 2'b10; // load has priority
        2'b01: operation = 2'b01; // shift
        2'b11: operation = 2'b10; // load has priority
        default: operation = 2'b00; // hold
    endcase
end

// Shift operation with barrel shifter approach
always @(*) begin
    case (operation)
        2'b01: next_q = {1'b0, q[3:1]}; // shift right with zero fill
        2'b10: next_q = data;           // load
        default: next_q = q;            // hold
    endcase
end

// Asynchronous reset and synchronous update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        q <= next_q;
    end
end

endmodule