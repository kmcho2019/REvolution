module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] buffer;
reg [1:0] ptr;  // Write pointer

always @(posedge clk or posedge areset) begin
    if (areset) begin
        buffer <= 4'b0;
        ptr <= 2'b0;
    end
    else if (load) begin
        buffer <= data;
        ptr <= 2'b0;
    end
    else if (ena) begin
        // Circular increment pointer
        ptr <= ptr + 1;
        // Clear the new position (right shift with zero fill)
        case (ptr + 1)
            2'd0: buffer[0] <= 1'b0;
            2'd1: buffer[1] <= 1'b0;
            2'd2: buffer[2] <= 1'b0;
            2'd3: buffer[3] <= 1'b0;
        endcase
    end
end

assign q = buffer;

endmodule