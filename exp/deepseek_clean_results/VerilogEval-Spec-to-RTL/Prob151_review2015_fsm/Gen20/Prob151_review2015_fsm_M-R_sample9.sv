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

    // Gray state encoding
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b11;
    localparam DONE     = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] counter;
    reg [2:0] pattern;

    // Next state combinational logic
    assign next_state = 
        (reset) ? IDLE :
        (state == IDLE && pattern == 3'b110 && data == 1'b1) ? SHIFT :
        (state == SHIFT && counter == 2'b11) ? COUNTING :
        (state == COUNTING && done_counting) ? DONE :
        (state == DONE && ack) ? IDLE :
        state;

    // State register update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Counter update
    always @(posedge clk) begin
        if (reset) begin
            counter <= 2'b0;
        end else if (state == SHIFT) begin
            counter <= counter + 1;
        end else if (state == IDLE) begin
            counter <= 2'b0;
        end
    end

    // Pattern register update
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 3'b0;
        end else if (state == IDLE) begin
            pattern <= {pattern[1:0], data};
        end else if (state == DONE && ack) begin
            pattern <= 3'b0;
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule