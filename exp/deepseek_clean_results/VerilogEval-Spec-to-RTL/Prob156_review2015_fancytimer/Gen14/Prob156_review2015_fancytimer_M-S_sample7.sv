module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // States
    localparam IDLE = 0;
    localparam COLLECT = 1;
    localparam COUNT = 2;
    localparam DONE = 3;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [13:0] cycles_left; // Max needed: (15+1)*1000 = 16000 (14 bits)

    // State machine and main logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= COLLECT;
                        shift_reg <= 4'b0;
                    end
                end

                COLLECT: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (&shift_reg[2:0]) begin // After 4 shifts
                        delay <= shift_reg;
                        cycles_left <= ({shift_reg, 10'b0} + {6'b0, 10'b1001110000}) - 1; // (delay+1)*1000-1
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    if (cycles_left == 0) begin
                        state <= DONE;
                    end else begin
                        cycles_left <= cycles_left - 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output generation
    assign counting = (state == COUNT);
    assign done = (state == DONE);

    // Count output shows current delay value (cycles_left/1000)
    always @(*) begin
        if (state == COUNT) begin
            count = cycles_left / 1000;
        end else begin
            count = 4'b0; // Don't-care when not counting
        end
    end

endmodule