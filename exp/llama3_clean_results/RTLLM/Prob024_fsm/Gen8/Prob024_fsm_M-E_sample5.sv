module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// Define the target sequence
parameter TARGET_SEQ = 5'b10011;

// Define the length of the shift register
parameter REG_LEN = 5;

// Shift register to hold the sequence
logic [REG_LEN-1:0] shift_reg;

// Comparator output
logic match_detected;

// Reset logic
always @(posedge RST) begin
    shift_reg <= {REG_LEN{1'b0}};
    MATCH <= 1'b0;
end

// Shift register logic
always_ff @(posedge CLK) begin
    if (RST) begin
        shift_reg <= {REG_LEN{1'b0}};
        MATCH <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[REG_LEN-2:0], IN};
    end
end

// Comparator logic
always_comb begin
    match_detected = (shift_reg == TARGET_SEQ);
end

// Output logic
always_ff @(posedge CLK) begin
    if (RST) begin
        MATCH <= 1'b0;
    end else begin
        MATCH <= match_detected;
    end
end

endmodule