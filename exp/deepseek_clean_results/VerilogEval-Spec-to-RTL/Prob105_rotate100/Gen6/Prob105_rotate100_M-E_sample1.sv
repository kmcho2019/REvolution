module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] storage;
reg [6:0] pointer; // 7 bits for 0-99 (100 positions)

// Combinational output logic
assign q = {storage[pointer +: (100-pointer)], storage[0 +: pointer]};

always @(posedge clk) begin
    if (load) begin
        storage <= data;
        pointer <= 7'd0;
    end else begin
        case (ena)
            2'b01: pointer <= (pointer == 7'd99) ? 7'd0 : pointer + 7'd1; // Right rotate (inc pointer)
            2'b10: pointer <= (pointer == 7'd0) ? 7'd99 : pointer - 7'd1; // Left rotate (dec pointer)
            default: ; // No change
        endcase
    end
end

endmodule