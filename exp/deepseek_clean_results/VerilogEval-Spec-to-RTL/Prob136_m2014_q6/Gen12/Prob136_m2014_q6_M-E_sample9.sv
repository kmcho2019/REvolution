module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State mapping via counter values
    // A=0, B=1, C=2, D=3, E=4, F=5
    reg [2:0] counter;

    // Next state calculation via arithmetic
    wire [2:0] next_counter;
    assign next_counter = 
        (counter == 0) ? (w ? 0 : 1) :       // A
        (counter == 1) ? (w ? 3 : 2) :       // B
        (counter == 2) ? (w ? 3 : 4) :        // C
        (counter == 3) ? (w ? 0 : 5) :       // D
        (counter == 4) ? (w ? 3 : 4) :        // E
        (counter == 5) ? (w ? 3 : 2) : 0;    // F

    // State transition
    always @(posedge clk) begin
        if (reset)
            counter <= 0;
        else
            counter <= next_counter;
    end

    // Output is high when in states E(4) or F(5)
    assign z = counter[2];

endmodule