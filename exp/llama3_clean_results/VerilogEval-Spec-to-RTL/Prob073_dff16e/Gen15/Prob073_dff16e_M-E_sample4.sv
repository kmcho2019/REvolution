module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [15:0] shiftReg;
reg [15:0] dffReg;

always @(posedge clk) begin
    if (~resetn) begin
        shiftReg <= 16'd0;
        dffReg <= 16'd0;
    end else begin
        shiftReg <= d;
        
        if (byteena[0]) begin
            dffReg[7:0] <= shiftReg[7:0];
        end
        if (byteena[1]) begin
            dffReg[15:8] <= shiftReg[15:8];
        end
    end
end

always @(posedge clk) begin
    q <= dffReg;
end

endmodule