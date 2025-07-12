module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Shift register to hold last 5 input bits
    reg [4:0] shift_reg;

    // Pattern to detect: 5'b10011
    localparam [4:0] PATTERN = 5'b10011;

    always @(posedge CLK) begin
        if (RST) begin
            shift_reg <= 5'b0;
            MATCH <= 1'b0;
        end else begin
            // Shift left and insert new bit at LSB
            shift_reg <= {shift_reg[3:0], IN};

            // Assert MATCH when shift_reg equals pattern after shift
            MATCH <= ({shift_reg[3:0], IN} == PATTERN);
        end
    end

endmodule