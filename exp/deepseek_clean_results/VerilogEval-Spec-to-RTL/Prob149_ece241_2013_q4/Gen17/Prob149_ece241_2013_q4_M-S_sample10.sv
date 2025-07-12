module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding matches water level hierarchy
    reg [1:0] state;
    wire [1:0] next_state;

    // State transition logic
    assign next_state = 
        (s == 3'b000) ? 2'b00 :  // Below s[0]
        (s == 3'b001) ? 2'b01 :  // Between s[1]-s[0]
        (s == 3'b011) ? 2'b10 :  // Between s[2]-s[1]
        2'b11;                  // Above s[2]

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to below s[0]
        else
            state <= next_state;
    end

    // Output logic
    assign fr0 = (state != 2'b11);  // On for all but above s[2]
    assign fr1 = (state == 2'b00) || (state == 2'b01);  // Below or low
    assign fr2 = (state == 2'b00);  // Only below s[0]

    // dfr asserted when next level is higher than current
    assign dfr = (next_state > state);

endmodule