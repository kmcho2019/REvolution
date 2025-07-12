module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] buffer [0:3];  // 4-entry circular buffer
reg [1:0] ptr;           // Current read pointer (points to MSB position)
reg [1:0] next_ptr;

// Pointer and buffer update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ptr <= 2'b11;  // Initialize to point to MSB
        buffer[3] <= 1'b0;
        buffer[2] <= 1'b0;
        buffer[1] <= 1'b0;
        buffer[0] <= 1'b0;
    end else if (load) begin
        ptr <= 2'b11;  // Reset pointer to MSB
        buffer[3] <= data[3];
        buffer[2] <= data[2];
        buffer[1] <= data[1];
        buffer[0] <= data[0];
    end else if (ena) begin
        ptr <= next_ptr;
    end
end

// Pointer arithmetic
always @(*) begin
    next_ptr = ptr - 1'b1;  // Automatically wraps around
end

// Output selection
assign q = {buffer[ptr],
            buffer[ptr == 2'b11 ? 2'b10 : ptr + 1'b1],
            buffer[ptr == 2'b11 ? 2'b01 : 
                  (ptr == 2'b10 ? 2'b00 : ptr + 2'b10)],
            buffer[ptr == 2'b11 ? 2'b00 : 
                  (ptr == 2'b10 ? 2'b01 : 
                  (ptr == 2'b01 ? 2'b10 : 2'b11))]};

endmodule