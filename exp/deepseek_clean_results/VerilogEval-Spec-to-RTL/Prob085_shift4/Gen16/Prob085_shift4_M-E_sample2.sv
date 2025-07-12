module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Operation encoding
localparam OP_RESET = 2'b00;
localparam OP_LOAD  = 2'b01;
localparam OP_SHIFT = 2'b10;
localparam OP_HOLD  = 2'b11;

reg [1:0] operation;

// Priority encoder for operations
always @(*) begin
    if (areset)
        operation = OP_RESET;
    else if (load)
        operation = OP_LOAD;
    else if (ena)
        operation = OP_SHIFT;
    else
        operation = OP_HOLD;
end

// Register update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        case (operation)
            OP_LOAD:  q <= data;
            OP_SHIFT: q <= {1'b0, q[3:1]};
            OP_HOLD:  q <= q;
            default:  q <= 4'b0; // OP_RESET handled by async reset
        endcase
    end
end

endmodule