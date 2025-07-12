module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] storage;
reg [1:0] ptr;  // Circular buffer pointer

// Circular output generation
assign q = (ptr == 2'b00) ? storage :
            (ptr == 2'b01) ? {storage[0], storage[3:1]} :
            (ptr == 2'b10) ? {storage[1:0], storage[3:2]} :
                             {storage[2:0], storage[3]};

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
        storage[ptr] <= 1'b0;  // Clear the outgoing bit
    end
end

endmodule