module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Pack inputs into a vector
    wire [2:0] inputs = {a, b, c};
    
    // Unpack outputs from a vector
    wire [3:0] outputs;
    assign {w, x, y, z} = outputs;

    // Implement as a case-based lookup table
    always @(*) begin
        case (inputs)
            3'b000: outputs = 4'b0000;
            3'b001: outputs = 4'b0001;
            3'b010: outputs = 4'b0110;
            3'b011: outputs = 4'b0111;
            3'b100: outputs = 4'b1000;
            3'b101: outputs = 4'b1001;
            3'b110: outputs = 4'b1110;
            3'b111: outputs = 4'b1111;
            default: outputs = 4'b0000;
        endcase
    end
endmodule