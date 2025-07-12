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

    // State encoding
    localparam IDLE    = 2'b00;
    localparam SHIFT   = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state;
    reg [2:0] pattern;  // Tracks both pattern match and shift count

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[1:0], data};
                    if (pattern == 3'b110 && data)  // Detect 1101
                        state <= SHIFT;
                end
                SHIFT: begin
                    pattern <= pattern + 1;
                    if (pattern == 3'b011)  // After 4 cycles
                        state <= COUNT;
                end
                COUNT: if (done_counting)
                    state <= DONE;
                DONE: if (ack)
                    state <= IDLE;
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule