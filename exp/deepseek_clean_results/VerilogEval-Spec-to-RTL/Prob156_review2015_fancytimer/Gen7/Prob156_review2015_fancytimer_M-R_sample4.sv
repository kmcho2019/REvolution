module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State definitions
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNT    = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [3:0] delay_counter;
    reg [9:0] interval_counter;
    reg [2:0] bit_count;

    // Continuous assignments for outputs
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    assign count = (state == COUNT) ? delay_counter : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            delay <= 4'b0;
            delay_counter <= 4'b0;
            interval_counter <= 10'b0;
            bit_count <= 3'b0;
        end else begin
            // Shift in data to pattern register continuously
            pattern <= {pattern[2:0], data};

            case (state)
                IDLE: begin
                    if (pattern == 4'b1101) begin
                        state <= CAPTURE;
                        bit_count <= 3'b0;
                        delay <= 4'b0;
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    bit_count <= bit_count + 1;

                    if (bit_count == 3'b011) begin
                        delay_counter <= delay;
                        state <= COUNT;
                        interval_counter <= 10'd999; // Counts 0-999 (1000 cycles)
                    end
                end

                COUNT: begin
                    if (interval_counter == 0) begin
                        if (delay_counter == 0) begin
                            state <= DONE;
                        end else begin
                            delay_counter <= delay_counter - 1;
                            interval_counter <= 10'd999;
                        end
                    end else begin
                        interval_counter <= interval_counter - 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule