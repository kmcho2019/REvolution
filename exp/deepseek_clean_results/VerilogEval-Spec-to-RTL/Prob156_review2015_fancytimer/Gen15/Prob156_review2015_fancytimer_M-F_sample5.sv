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
    reg [3:0] pattern_reg;  // For 1101 detection
    reg [3:0] delay_reg;    // For delay collection
    reg [2:0] bit_count;    // Count collected bits
    reg [13:0] cycles_left; // Max needed: (15+1)*1000 = 16000 (14 bits)

    // State machine and main logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= COLLECT;
                        bit_count <= 0;
                    end
                end

                COLLECT: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3) begin // Collected 4 bits
                        cycles_left <= (delay_reg + 1) * 1000 - 1;
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
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output generation
    assign counting = (state == COUNT);
    assign done = (state == DONE);

    // Count output shows current remaining time
    always @(*) begin
        if (state == COUNT) begin
            count = (cycles_left) / 1000;
        end else begin
            count = 4'b0; // Don't-care when not counting
        end
    end

endmodule