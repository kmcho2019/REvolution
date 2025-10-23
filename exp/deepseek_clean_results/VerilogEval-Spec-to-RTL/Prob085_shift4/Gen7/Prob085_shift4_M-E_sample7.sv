module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] storage;
reg [1:0] pointer;  // Tracks virtual start position

// Output is always a rotated view of storage based on pointer
assign q = {storage[pointer-:4]};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        storage <= 4'b0;
        pointer <= 2'b0;
    end
    else if (load) begin
        storage <= data;
        pointer <= 2'b0;  // Reset pointer on load
    end
    else if (ena) begin
        // Virtual shift by incrementing pointer
        pointer <= pointer + 1;
        // Physical storage remains unchanged except for new MSB
        storage[{pointer+1}] <= 1'b0;
    end
end

endmodule