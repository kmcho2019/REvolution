module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] mem [0:3];  // 4-element circular buffer
reg [1:0] ptr;        // Current starting position pointer

always @(posedge clk or posedge areset) begin
    if (areset) begin
        mem[0] <= 0;
        mem[1] <= 0;
        mem[2] <= 0;
        mem[3] <= 0;
        ptr <= 0;
    end
    else if (load) begin
        mem[0] <= data[0];
        mem[1] <= data[1];
        mem[2] <= data[2];
        mem[3] <= data[3];
        ptr <= 0;
    end
    else if (ena) begin
        ptr <= ptr + 1;  // Virtual shift by moving pointer
        mem[(ptr+3)%4] <= 0;  // Clear what would be the new MSB
    end
end

// Output is always the 4 elements starting from ptr
always @(*) begin
    q[0] = mem[ptr];
    q[1] = mem[(ptr+1)%4];
    q[2] = mem[(ptr+2)%4];
    q[3] = mem[(ptr+3)%4];
end

endmodule