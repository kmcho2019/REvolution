module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] buffer;

// Circular buffer implementation
always @(posedge clk) begin
    if (enable) begin
        buffer <= {buffer[6:0], S};
    end
end

// Output logic using assign statement
wire [2:0] addr;
assign addr = {A, B, C};
assign Z = (addr == 3'b000) ? buffer[0] :
           (addr == 3'b001) ? buffer[1] :
           (addr == 3'b010) ? buffer[2] :
           (addr == 3'b011) ? buffer[3] :
           (addr == 3'b100) ? buffer[4] :
           (addr == 3'b101) ? buffer[5] :
           (addr == 3'b110) ? buffer[6] :
           (addr == 3'b111) ? buffer[7] : 1'bx;

endmodule