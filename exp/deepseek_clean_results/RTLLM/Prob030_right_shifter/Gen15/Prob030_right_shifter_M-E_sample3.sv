module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] data_reg;
reg [2:0] ptr;  // Points to current MSB position
wire [2:0] next_ptr = ptr - 1;  // Circular decrement

// Virtual output mapping
assign q = {
    data_reg[ptr],
    data_reg[ptr-1],
    data_reg[ptr-2],
    data_reg[ptr-3],
    data_reg[ptr-4],
    data_reg[ptr-5],
    data_reg[ptr-6],
    data_reg[ptr-7]
};

always @(posedge clk) begin
    // Store new input at current pointer position
    data_reg[ptr] <= d;
    
    // Update pointer (circular decrement)
    ptr <= next_ptr;
    
    // Reset initialization
    if (ptr === 3'bx) begin
        ptr <= 0;
        data_reg <= 8'b0;
    end
end

endmodule