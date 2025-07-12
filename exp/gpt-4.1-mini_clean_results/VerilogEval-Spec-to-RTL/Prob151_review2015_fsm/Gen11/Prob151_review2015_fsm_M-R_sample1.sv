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

    // State encoding (3-bit)
    localparam IDLE  = 3'd0,
               SHIFT = 3'd1,
               COUNT = 3'd2,
               DONE  = 3'd3;

    reg [2:0] state, next_state;
    reg [1:0] shift_count;         // Counts 4 shift cycles (0 to 3)
    reg [3:0] data_window;         // 4-bit window of recent serial bits

    // Shift in serial data to 4-bit window on each clock
    always @(posedge clk) begin
        if (reset) begin
            data_window <= 4'd0;
        end else begin
            data_window <= {data_window[2:0], data};
        end
    end

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                // Detect start pattern 1101 in data_window
                if (data_window == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                // After shifting 4 bits, go to COUNT
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                // Wait for done_counting signal
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                // Wait for ack to return to IDLE
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic based on state
    always @(*) begin
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT: shift_ena = 1'b1;
            COUNT: counting  = 1'b1;
            DONE:  done      = 1'b1;
        endcase
    end

endmodule