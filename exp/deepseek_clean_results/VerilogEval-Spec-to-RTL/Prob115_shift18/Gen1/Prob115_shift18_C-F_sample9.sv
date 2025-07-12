module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Parameterized sign extension for arithmetic right shifts
wire [7:0] sign_extension = {8{q[63]}};

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Synchronous load has highest priority
    end
    else if (ena) begin
        case (amount)
            // Left shifts (pad with 0)
            2'b00: q <= {q[62:0], 1'b0};        // Shift left by 1 bit
            2'b01: q <= {q[55:0], 8'b0};        // Shift left by 8 bits
            
            // Arithmetic right shifts (sign-extended)
            2'b10: q <= {sign_extension[0], q[63:1]};   // Shift right by 1 bit
            2'b11: q <= {sign_extension, q[63:8]};       // Shift right by 8 bits
        endcase
    end
end

endmodule