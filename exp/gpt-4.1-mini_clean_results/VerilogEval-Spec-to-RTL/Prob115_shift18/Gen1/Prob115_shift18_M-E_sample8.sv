module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    // Intermediate signals for 8-bit shift stage
    reg [63:0] shift8_out;
    // Final shifted value after possible 1-bit shift
    reg [63:0] shift1_out;

    wire msb = q[63];

    always @(*) begin
        // 8-bit shift stage
        case (amount)
            2'b00, 2'b10: begin
                // No 8-bit shift for amount 00 and 10 (only 1-bit shift)
                shift8_out = q;
            end
            2'b01: begin
                // Shift left by 8 bits
                shift8_out = {q[55:0], 8'b0};
            end
            2'b11: begin
                // Arithmetic shift right by 8 bits: replicate MSB
                shift8_out = {{8{msb}}, q[63:8]};
            end
            default: shift8_out = q;
        endcase
    end

    always @(*) begin
        // 1-bit shift stage on shift8_out
        case (amount)
            2'b00: begin
                // Shift left by 1 bit
                shift1_out = {shift8_out[62:0], 1'b0};
            end
            2'b01: begin
                // No 1-bit shift (already shifted 8 bits)
                shift1_out = shift8_out;
            end
            2'b10: begin
                // Arithmetic shift right by 1 bit
                shift1_out = {shift8_out[63], shift8_out[63:1]};
            end
            2'b11: begin
                // No 1-bit shift (already shifted 8 bits)
                shift1_out = shift8_out;
            end
            default: shift1_out = shift8_out;
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift1_out;
        end
    end

endmodule