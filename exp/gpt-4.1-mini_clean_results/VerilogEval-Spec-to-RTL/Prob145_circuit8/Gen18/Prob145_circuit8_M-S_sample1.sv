module TopModule(
    input       clock,
    input       a,
    output reg  p,
    output reg  q
);

    // Update p on rising edge of clock to input 'a'
    always @(posedge clock) begin
        p <= a;
    end

    // Update q on falling edge of clock to previous p
    always @(negedge clock) begin
        q <= p;
    end

endmodule