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
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101)
                        state <= SHIFT;
                end

                SHIFT: begin
                    pattern <= {pattern[2:0], data};
                    if (&pattern[1:0])  // After 4 shifts (bits 1:0 will be 11)
                        state <= COUNT;
                end

                COUNT: begin
                    if (done_counting)
                        state <= DONE;
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 0;
                    end
                end
            endcase
        end
    end

    assign shift_ena = (state == SHIFT);
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule