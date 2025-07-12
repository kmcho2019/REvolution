module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [1:0] state, prev_state;
    wire [1:0] next_state;

    // State encoding:
    // 00 - Below s[0] (no sensors)
    // 01 - Between s[0] and s[1] (only s[0])
    // 10 - Between s[1] and s[2] (s[0] and s[1])
    // 11 - Above s[2] (all sensors)

    assign next_state = (s == 3'b000) ? 2'b00 :  // Below s[0]
                       (s == 3'b001) ? 2'b01 :  // Between s[0]-s[1]
                       (s == 3'b011) ? 2'b10 :  // Between s[1]-s[2]
                       2'b11;                   // Above s[2]

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            prev_state <= 2'b00;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_state <= state;
            state <= next_state;
            
            // Output logic
            fr0 <= (state != 2'b11);  // On unless above s[2]
            fr1 <= (state == 2'b00) || (state == 2'b01);  // On when below s[1]
            fr2 <= (state == 2'b00);  // On only when below s[0]
            dfr <= (state > prev_state);  // On when water level is rising
        end
    end

endmodule