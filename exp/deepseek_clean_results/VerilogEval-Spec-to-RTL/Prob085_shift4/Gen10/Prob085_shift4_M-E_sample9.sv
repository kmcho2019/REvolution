module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] storage;
reg [1:0] ptr;  // Pointer to current start position

// Circular buffer implementation
always @(posedge clk or posedge areset) begin
    if (areset) begin
        storage <= 4'b0;
        ptr <= 2'b0;
    end
    else if (load) begin
        storage <= data;
        ptr <= 2'b0;
    end
    else if (ena) begin
        ptr <= ptr + 1;  // Move pointer right (circular)
    end
end

// Output calculation based on pointer position
assign q = (ptr == 2'b00) ? storage :
           (ptr == 2'b01) ? {1'b0, storage[3:1]} :
           (ptr == 2'b10) ? {2'b0, storage[3:2]} :
                            {3'b0, storage[3]};

endmodule