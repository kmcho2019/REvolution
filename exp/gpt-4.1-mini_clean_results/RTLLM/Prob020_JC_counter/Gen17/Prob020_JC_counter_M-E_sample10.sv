module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

    reg [62:0] shift_reg; // Holds bits [63:1] of Q internally (63 bits)
    reg        lsb_reg;   // Holds bit Q[0] internally

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 63'b0;
            lsb_reg   <= 1'b0;
            Q         <= 64'b0;
        end else begin
            // Next LSB is MSB of Q from current Q[63]
            // Johnson logic: if LSB=0, next MSB=1, else 0
            lsb_reg <= ~lsb_reg;
            // Shift the 63-bit register right, insert lsb_reg at MSB
            shift_reg <= {lsb_reg, shift_reg[62:1]};
            // Combine shift_reg and lsb_reg to form Q
            Q <= {shift_reg, lsb_reg};
        end
    end

endmodule