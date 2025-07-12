module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Control signal encoding
wire [1:0] ctrl;
assign ctrl = {load, ena};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        case (ctrl)
            2'b1x: q <= data;      // Load has highest priority
            2'b01: q <= {1'b0, q[3:1]};  // Shift right
            default: q <= q;        // Hold value
        endcase
    end
end

endmodule