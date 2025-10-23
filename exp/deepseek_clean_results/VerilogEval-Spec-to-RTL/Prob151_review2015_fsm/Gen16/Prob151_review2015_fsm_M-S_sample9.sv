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
    localparam IDLE     = 2'b00;
    localparam SHIFT    = 2'b01;
    localparam COUNTING = 2'b10;

    reg [1:0] state;
    reg [1:0] counter;
    reg [2:0] pattern; // Stores last 3 bits for pattern detection

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counter <= 2'b0;
            pattern <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[1:0], data};
                    if (pattern == 3'b110 && data == 1'b1) begin
                        state <= SHIFT;
                        counter <= 2'b0;
                    end
                end

                SHIFT: begin
                    counter <= counter + 1;
                    if (counter == 2'b11)
                        state <= COUNTING;
                end

                COUNTING: begin
                    if (done_counting) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output assignments
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == COUNTING && done_counting);

endmodule