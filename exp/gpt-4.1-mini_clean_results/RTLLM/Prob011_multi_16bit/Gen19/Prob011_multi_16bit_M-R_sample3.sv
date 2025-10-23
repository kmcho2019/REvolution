module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg         done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    reg [4:0] shift_count;      // counts from 0 to 16
    reg [15:0] multiplicand;    // stored ain
    reg [15:0] multiplier;      // stored bin, shifted each cycle
    reg [31:0] product_acc;     // accumulator for the result

    // FSM state register and next state logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = RUN;
                else
                    next_state = IDLE;
            end
            RUN: begin
                if (shift_count == 5'd16)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                if (!start)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // shift_count and done flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_count <= 5'd0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_count <= 5'd0;
                    done <= 1'b0;
                end
                RUN: begin
                    shift_count <= shift_count + 5'd1;
                    done <= 1'b0;
                end
                DONE: begin
                    done <= 1'b1;
                end
                default: begin
                    shift_count <= 5'd0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Datapath: multiplicand, multiplier and product accumulator
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
            product_acc <= 32'd0;
            yout <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Load inputs at start
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= bin;
                        product_acc <= 32'd0;
                    end
                    yout <= 32'd0;
                end
                RUN: begin
                    // On each shift_count cycle, check LSB of multiplier, add multiplicand if needed, then shift right
                    if (multiplier[0] == 1'b1) begin
                        // Add multiplicand shifted by current shift_count to product_acc
                        product_acc <= product_acc + ( {16'd0, multiplicand} << shift_count );
                    end
                    multiplier <= multiplier >> 1;
                    yout <= product_acc; // Update output with partial product
                end
                DONE: begin
                    yout <= product_acc; // Final product output
                end
                default: begin
                    multiplicand <= 16'd0;
                    multiplier <= 16'd0;
                    product_acc <= 32'd0;
                    yout <= 32'd0;
                end
            endcase
        end
    end

endmodule