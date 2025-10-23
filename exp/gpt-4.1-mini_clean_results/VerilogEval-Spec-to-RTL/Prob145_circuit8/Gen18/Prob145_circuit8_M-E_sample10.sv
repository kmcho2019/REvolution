module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // State encoding p and q: state[1] = p, state[0] = q

initial begin
    state = 2'bxx; // Start with unknown outputs per waveform initial x
    p = 1'bx;
    q = 1'bx;
end

// Update state on rising edge of clock based on input 'a' and current state
always @(posedge clock) begin
    case (state)
        2'b00: begin
            // From 00, if a=1 go to 11 else remain 00
            if (a)
                state <= 2'b11;
            else
                state <= 2'b00;
        end
        2'b01: begin
            // From 01, if a=1 remain 11 else remain 01
            if (a)
                state <= 2'b11;
            else
                state <= 2'b01;
        end
        2'b11: begin
            // From 11, if a=0 go to 00 else remain 11
            if (!a)
                state <= 2'b00;
            else
                state <= 2'b11;
        end
        default: begin
            // If unknown state, move to 00 on next rising clock
            state <= 2'b00;
        end
    endcase
end

// Update outputs p and q on falling edge of clock to reflect stable values
always @(negedge clock) begin
    p <= state[1];
    q <= state[0];
end

endmodule