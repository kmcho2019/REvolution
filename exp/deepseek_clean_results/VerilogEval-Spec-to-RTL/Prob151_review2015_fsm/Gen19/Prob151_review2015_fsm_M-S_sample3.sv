module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

    // Simplified state encoding
    localparam IDLE      = 2'b00;
    localparam SHIFT     = 2'b01;
    localparam COUNTING  = 2'b10;
    localparam DONE_ACK  = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;  // Stores shifted-in bits for detection

    // Continuous pattern shifting and state transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
        end else begin
            pattern <= {pattern[2:0], data};  // Always shift in new data

            case (state)
                IDLE: 
                    if (pattern == 4'b1101) state <= SHIFT;

                SHIFT: 
                    if (&pattern[1:0]) state <= COUNTING;  // After 2 more cycles (total 4)

                COUNTING: 
                    if (done_counting) state <= DONE_ACK;

                DONE_ACK: 
                    if (ack) state <= IDLE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE_ACK);

endmodule