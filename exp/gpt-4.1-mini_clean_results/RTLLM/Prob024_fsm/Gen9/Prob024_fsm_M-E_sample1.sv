module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding for matched prefix count:
    // 0: no match
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    reg [2:0] state;

    // Shift register to hold last 3 input bits for prefix detection
    reg [2:0] shift_in;

    // Sequential logic to update shift register and state
    always @(posedge CLK) begin
        if (RST) begin
            state <= 3'd0;
            shift_in <= 3'b000;
        end else begin
            // Shift in new input bit
            shift_in <= {shift_in[1:0], IN};

            // Next state logic based on current state and new input (Mealy)
            case (state)
                3'd0: state <= (IN) ? 3'd1 : 3'd0;                  // waiting for '1'
                3'd1: state <= (IN) ? 3'd1 : 3'd2;                  // matched '1', check for '0'
                3'd2: state <= (IN) ? 3'd1 : 3'd3;                  // matched '10', check for '0'
                3'd3: state <= (IN) ? 3'd4 : 3'd0;                  // matched '100', check for '1'
                3'd4: state <= (IN) ? 3'd1 : 3'd2;                  // matched '1001', check for last '1'
                default: state <= 3'd0;
            endcase
        end
    end

    // MATCH output is 1 when in state 4 and input IN=1 (completing '10011')
    assign MATCH = (state == 3'd4) && IN;

endmodule