module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    // Internal signal for shifted value
    reg [63:0] shifted;

    always @(*) begin
        case (amount)
            2'b00: begin
                // Shift left by 1 bit (logical)
                shifted = q << 1;
            end
            2'b01: begin
                // Shift left by 8 bits (logical)
                shifted = q << 8;
            end
            2'b10: begin
                // Arithmetic right shift by 1 bit
                // replicate MSB at top bit
                shifted = {q[63], q[63:1]};
            end
            2'b11: begin
                // Arithmetic right shift by 8 bits
                shifted = { {8{q[63]}}, q[63:8] };
            end
            default: shifted = q;
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;       // synchronous load
        end else if (ena) begin
            q <= shifted;    // shift as per amount
        end
        // else hold current q
    end

endmodule