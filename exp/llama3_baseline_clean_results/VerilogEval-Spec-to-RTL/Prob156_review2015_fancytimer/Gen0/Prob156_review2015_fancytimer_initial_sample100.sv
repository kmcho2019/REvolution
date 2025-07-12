module TopModule(
    input         clk,
    input         reset,
    input         data,
    output [3:0]  count,
    output        counting,
    output        done,
    input         ack
);

    // Define states
    parameter IDLE   = 4'd0;
    parameter SHIFT  = 4'd1;
    parameter COUNT  = 4'd2;
    parameter DONE   = 4'd3;
    parameter RESET  = 4'd4;

    // State register
    reg [3:0] state;
    reg [3:0] next_state;

    // Shift register for pattern detection
    reg [3:0] pattern;

    // Shift register for delay
    reg [3:0] delay;

    // Counter for counting
    reg [19:0] counter;

    // Count output register
    reg [3:0] count_reg;

    // Output registers
    reg counting_reg;
    reg done_reg;

    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'd0;
        end else if (state == IDLE) begin
            pattern <= {pattern[2:0], data};
        end
    end

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern == 4'd13 && data == 1'd1) begin
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE;
                end
            end
            SHIFT: begin
                if (counter == 4'd4) begin
                    next_state = COUNT;
                end else begin
                    next_state = SHIFT;
                end
            end
            COUNT: begin
                if (counter == ((delay + 1) * 10'd1000)) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNT;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 20'd0;
        end else if (state == SHIFT) begin
            if (counter < 4'd4) begin
                counter <= counter + 1'd1;
            end
        end else if (state == COUNT) begin
            counter <= counter + 1'd1;
        end else if (state == DONE) begin
            counter <= 20'd0;
        end
    end

    // Delay logic
    always @(posedge clk) begin
        if (reset) begin
            delay <= 4'd0;
        end else if (state == SHIFT) begin
            if (counter == 1'd0) begin
                delay <= {data, 3'd0};
            end else if (counter == 1'd1) begin
                delay <= {delay[2:0], data};
            end else if (counter == 1'd2) begin
                delay <= {delay[1:0], data, delay[3]};
            end else if (counter == 1'd3) begin
                delay <= {data, delay[3:1]};
            end
        end
    end

    // Count output logic
    always @(posedge clk) begin
        if (reset) begin
            count_reg <= 4'd0;
        end else if (state == COUNT) begin
            if (counter < ((delay + 1) * 10'd1000 - 10'd1000)) begin
                count_reg <= delay;
            end else if (counter < ((delay) * 10'd1000 - 10'd1000)) begin
                count_reg <= delay - 1'd1;
            end else if (counter < ((delay - 1'd1) * 10'd1000 - 10'd1000)) begin
                count_reg <= delay - 2'd2;
            end else if (counter < ((delay - 2'd2) * 10'd1000 - 10'd1000)) begin
                count_reg <= delay - 3'd3;
            end else if (counter < ((delay - 3'd3) * 10'd1000 - 10'd1000)) begin
                count_reg <= delay - 4'd4;
            end else begin
                count_reg <= 4'd0;
            end
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting_reg <= 1'd0;
            done_reg <= 1'd0;
        end else begin
            state <= next_state;
            if (state == COUNT) begin
                counting_reg <= 1'd1;
            end else begin
                counting_reg <= 1'd0;
            end
            if (state == DONE) begin
                done_reg <= 1'd1;
            end else begin
                done_reg <= 1'd0;
            end
        end
    end

    assign count = count_reg;
    assign counting = counting_reg;
    assign done = done_reg;

endmodule