module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    localparam [1:0]
        SEARCH = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] shift_count, next_shift_count;
    reg [3:0] pattern_reg, next_pattern_reg;

    // Next-state and pattern register logic
    always @(*) begin
        next_pattern_reg = {pattern_reg[2:0], data};
        next_shift_count = shift_count;
        next_state = state;

        case (state)
            SEARCH: begin
                if (next_pattern_reg == 4'b1101) begin
                    next_state = SHIFT;
                    next_shift_count = 2'd0;
                end
            end
            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = COUNT;
                next_shift_count = shift_count + 1'b1;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_count <= 2'd0;
            pattern_reg <= 4'd0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
            if (state == SEARCH)
                pattern_reg <= next_pattern_reg;
        end
    end

    // Output logic (Moore outputs)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE);
    end

endmodule