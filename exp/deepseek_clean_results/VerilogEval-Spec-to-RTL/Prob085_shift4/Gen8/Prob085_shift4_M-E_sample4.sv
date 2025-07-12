module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] storage;
reg [1:0] ptr;  // Points to current q[0] position

// Rotation logic for output
assign q = {storage, storage} >> ptr;  // Concatenate and shift for rotation

always @(posedge clk or posedge areset) begin
    if (areset) begin
        storage <= 4'b0;
        ptr <= 2'b0;
    end
    else if (load) begin
        storage <= data;
        ptr <= 2'b0;  // Reset pointer on load
    end
    else if (ena) begin
        ptr <= ptr + 1;  // Circular increment
    end
end

endmodule