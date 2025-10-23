module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] pointer; // 7 bits for 0-127 (covers 100 positions)

// Virtual rotation implementation
wire [6:0] next_ptr = 
    load ? 7'b0 : 
    (ena == 2'b01) ? pointer + 7'd1 : 
    (ena == 2'b10) ? pointer - 7'd1 : 
    pointer;

// Circular buffer output selection
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : rot_mux
        wire [6:0] offset = i + pointer;
        wire [6:0] wrapped_offset = (offset >= 100) ? offset - 100 : offset;
        assign q[i] = storage[wrapped_offset];
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        storage <= data;
    end
    pointer <= next_ptr;
end

endmodule