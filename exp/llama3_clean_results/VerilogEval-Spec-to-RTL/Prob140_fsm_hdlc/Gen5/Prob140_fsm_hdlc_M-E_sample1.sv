module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

reg [7:0] shift_reg; // Shift register to store last 8 bits
reg [2:0] consecutive_ones; // Counter for consecutive '1's
reg [2:0] total_bits; // Counter for total bits in current sequence

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 8'b00000000;
        consecutive_ones <= 3'b000;
        total_bits <= 3'b000;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        // Update shift register
        shift_reg <= {shift_reg[6:0], in};

        // Update counters
        if (in) begin
            consecutive_ones <= consecutive_ones + 1;
            total_bits <= total_bits + 1;
        end else begin
            consecutive_ones <= 3'b000;
            total_bits <= 3'b000;
        end

        // Check for 'flag' condition
        if (shift_reg == 8'b01111110) begin
            flag <= 1'b1;
        end else begin
            flag <= 1'b0;
        end

        // Check for 'disc' condition
        if (shift_reg == 8'b01111100 && in == 1'b0) begin
            disc <= 1'b1;
        end else begin
            disc <= 1'b0;
        end

        // Check for 'err' condition
        if (consecutive_ones >= 3'b111) begin
            err <= 1'b1;
        end else begin
            err <= 1'b0;
        end
    end
end

endmodule