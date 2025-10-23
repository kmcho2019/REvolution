module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;
reg [1:0] pulse_counter;

// p is high when a is high during clock high
assign p = p_reg;

// q maintains its state until reset
assign q = q_reg;

always @(posedge clock) begin
    p_reg <= a;  // p follows a during clock high
end

always @(posedge clock) begin
    // Count consecutive p pulses
    if (p_reg && a) begin
        if (pulse_counter < 2'b11)
            pulse_counter <= pulse_counter + 1;
    end
    else begin
        pulse_counter <= 2'b00;
    end

    // Set q after 3 p pulses
    if (pulse_counter == 2'b10 && p_reg && a) begin
        q_reg <= 1'b1;
    end
    // Reset q when a specific pattern occurs
    else if (q_reg && !a && !p_reg) begin
        q_reg <= 1'b0;
    end
end

endmodule