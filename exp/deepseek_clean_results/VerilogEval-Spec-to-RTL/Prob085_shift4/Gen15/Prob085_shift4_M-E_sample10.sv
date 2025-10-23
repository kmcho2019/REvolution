module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg [3:0] buffer;
reg [1:0] ptr;  // Pointer to current window start

always @(posedge clk or posedge areset) begin
    if (areset) begin
        buffer <= 4'b0;
        ptr <= 2'b0;
        q <= 4'b0;
    end else if (load) begin
        buffer <= data;
        ptr <= 2'b0;
        q <= data;
    end else if (ena) begin
        ptr <= ptr + 1;
        // Update output window based on new pointer position
        case (ptr)
            2'b00: q <= {1'b0, buffer[3:1]};
            2'b01: q <= {2'b0, buffer[3:2]};
            2'b10: q <= {3'b0, buffer[3]};
            2'b11: q <= 4'b0;
        endcase
    end
end

endmodule