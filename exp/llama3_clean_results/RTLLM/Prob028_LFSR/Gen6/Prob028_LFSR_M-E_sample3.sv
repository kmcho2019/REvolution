module LFSR_Hybrid(
    input           clk,  // Clock signal for the primary LFSR
    input           clk_slow,  // Clock signal for the secondary LFSR
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Internal signals for the primary LFSR
reg [3:0] primary_state;
reg [3:0] next_primary_state;

// Internal signals for the secondary LFSR
reg [3:0] secondary_state;
reg [3:0] next_secondary_state;

// Lookup table to store the tap positions
reg [1:0] tap_positions;

// Combinational logic to calculate the next state of the primary LFSR
always @(*) begin
    // Calculate the feedback based on the current tap positions
    case (tap_positions)
        2'b00: next_primary_state = {primary_state[2:0], primary_state[3] ^ primary_state[2]};
        2'b01: next_primary_state = {primary_state[2:0], primary_state[3] ^ primary_state[1]};
        2'b10: next_primary_state = {primary_state[2:0], primary_state[3] ^ primary_state[0]};
        2'b11: next_primary_state = {primary_state[2:0], primary_state[3] ^ primary_state[0] ^ primary_state[1]};
    endcase
end

// Combinational logic to calculate the next state of the secondary LFSR
always @(*) begin
    next_secondary_state = {secondary_state[2:0], secondary_state[3] ^ secondary_state[0]};
end

// Handle the clock edge and reset conditions for the primary LFSR
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        primary_state <= 4'b0;
    end else begin
        // Update the primary LFSR state with the calculated next state
        primary_state <= next_primary_state;
    end
end

// Handle the clock edge and reset conditions for the secondary LFSR
always @ (posedge clk_slow) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        secondary_state <= 4'b0;
        tap_positions <= 2'b00;
    end else begin
        // Update the secondary LFSR state with the calculated next state
        secondary_state <= next_secondary_state;
        // Update the tap positions based on the secondary LFSR state
        case (secondary_state)
            4'b0000: tap_positions <= 2'b00;
            4'b0001: tap_positions <= 2'b01;
            4'b0010: tap_positions <= 2'b10;
            4'b0011: tap_positions <= 2'b11;
        endcase
    end
end

// Assign the output
always @(*) begin
    out = primary_state;
end

endmodule