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

    // FSM states
    localparam IDLE  = 3'd0;
    localparam SHIFT = 3'd1;
    localparam COUNT = 3'd2;
    localparam DONE  = 3'd3;

    reg [2:0] state, next_state;

    // 4-bit shift register to detect pattern 1101
    reg [3:0] shift_reg;

    // 2-bit counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // Synchronous shift register capturing input bits each clock cycle
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    // FSM state register and shift count update
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Check if pattern 1101 detected on shift_reg
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = IDLE;
            end
            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Outputs synchronous to state
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;
        end else begin
            shift_ena <= (state == SHIFT);
            counting  <= (state == COUNT);
            done      <= (state == DONE);
        end
    end

endmodule