module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] input_bits;  // internal register to store input bits
reg [4:0] bit_count;    // counter to keep track of the number of input bits
reg carry;              // carry bit for 2's complement computation

always @(posedge clk or posedge areset) begin
    if (areset) begin
        input_bits <= 0;  // reset input bits
        bit_count <= 0;   // reset bit count
        carry <= 1'b0;    // reset carry bit
        z <= 1'b0;        // reset output
    end else begin
        if (bit_count == 0) begin
            input_bits <= {31'd0, x};  // store first input bit
            bit_count <= 1;            // increment bit count
            carry <= 1'b0;             // reset carry bit
        end else if (bit_count < 32) begin
            input_bits <= {input_bits[30:0], x};  // shift input bits and store new bit
            bit_count <= bit_count + 1;           // increment bit count
        end
        
        // compute 2's complement
        if (bit_count > 0) begin
            z <= ~(x ^ carry);  // output bit is inverse of input bit XOR carry
            carry <= ~(x ^ carry);  // update carry bit
        end
    end
end

endmodule