module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [1:0] ptr;  // Pointer to current "first" position
reg [3:0] buffer [0:3];  // Circular buffer storage

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ptr <= 2'b0;
        for (i = 0; i < 4; i = i + 1)
            buffer[i] <= 1'b0;
    end
    else if (load) begin
        // Load operation fills all positions
        for (i = 0; i < 4; i = i + 1)
            buffer[i] <= data[i];
        ptr <= 2'b0;  // Reset pointer
    end
    else if (ena) begin
        // Shift operation only moves pointer
        ptr <= ptr + 1;
        // Insert zero at new position
        buffer[(ptr + 1) % 4] <= 1'b0;
    end
end

// Output is rotated view of the buffer based on pointer
assign q[0] = buffer[ptr];
assign q[1] = buffer[(ptr + 1) % 4];
assign q[2] = buffer[(ptr + 2) % 4];
assign q[3] = buffer[(ptr + 3) % 4];

endmodule