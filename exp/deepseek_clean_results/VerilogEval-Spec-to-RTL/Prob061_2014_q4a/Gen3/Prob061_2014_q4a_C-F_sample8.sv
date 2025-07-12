module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg [1:0] operation;
wire next_Q;

// Operation decode: 2'b00 = hold, 2'b01 = shift, 2'b10 = load
always @(*) begin
    case ({L, E})
        2'b1x: operation = 2'b10;  // Load has priority
        2'b01: operation = 2'b01;  // Shift when enabled
        default: operation = 2'b00; // Hold otherwise
    endcase
end

// Input selection
assign next_Q = (operation == 2'b10) ? R : 
                (operation == 2'b01) ? w : 
                Q;

// Register the value
always @(posedge clk) begin
    Q <= next_Q;
end

endmodule