module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] physical_reg;
reg [1:0] pointer;  // Points to current q[0] position

// Physical register and pointer update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        physical_reg <= 4'b0;
        pointer <= 2'b00;
    end else if (load) begin
        physical_reg <= data;
        pointer <= 2'b00;
    end else if (ena) begin
        pointer <= pointer + 1;  // Circular increment
    end
end

// Output selection based on pointer
assign q = {physical_reg[pointer],
            physical_reg[(pointer+1)%4],
            physical_reg[(pointer+2)%4],
            physical_reg[(pointer+3)%4]};

endmodule