module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Define tap positions using a bitmask
localparam [31:0] TAP_MASK = 32'h8000_0403; // Bits 32(MSB),22,2,1 set

wire [31:0] xor_modified;
wire [31:0] next_state;

// Parallel XOR network for all tap positions
assign xor_modified = q ^ {32{q[0]}};

// Select between original and XOR-modified bits based on tap mask
assign next_state = {xor_modified[31], 
                    (TAP_MASK[30:0] & xor_modified[30:0]) | 
                    (~TAP_MASK[30:0] & q[30:0])};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;  // Synchronous reset to initial value
    end else begin
        q <= next_state;
    end
end

endmodule