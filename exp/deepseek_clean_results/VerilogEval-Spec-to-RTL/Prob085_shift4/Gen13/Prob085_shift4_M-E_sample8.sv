module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [1:0] ptr;  // Pointer to current "end" of shift register
reg [3:0] mem [0:3];  // Circular buffer storage

integer i;

// Output is always the 4 most recent values (circularly)
assign q = {mem[ptr], mem[(ptr+3'd1)%4], mem[(ptr+3'd2)%4], mem[(ptr+3'd3)%4]};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ptr <= 2'b0;
        for (i = 0; i < 4; i = i + 1) begin
            mem[i] <= 1'b0;
        end
    end else if (load) begin
        ptr <= 2'b0;
        mem[0] <= data[3];
        mem[1] <= data[2];
        mem[2] <= data[1];
        mem[3] <= data[0];
    end else if (ena) begin
        ptr <= (ptr + 2'd1) % 4;
        mem[(ptr + 2'd1) % 4] <= 1'b0;
    end
end

endmodule