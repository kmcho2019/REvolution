module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        ACCUMULATE = 2'd1
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;
    reg [9:0] sum_out;
    reg       valid_pulse;

    // Next state and outputs combinational logic
    always @(*) begin
        next_state = state;
        valid_pulse = 1'b0;
        sum_out = 10'd0;

        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = ACCUMULATE;
            end
            ACCUMULATE: begin
                if (valid_in) begin
                    if (count == 2'd3) begin
                        // On 4th valid data, generate output pulse
                        valid_pulse = 1'b1;
                        sum_out = accumulator + data_in;
                        next_state = valid_in ? ACCUMULATE : IDLE;
                    end
                end else begin
                    // If no valid input, remain in ACCUMULATE waiting
                    next_state = ACCUMULATE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, accumulator, count updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            accumulator <= 10'd0;
            count       <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= valid_pulse;

            if (state == IDLE) begin
                // Reset accumulator and count at IDLE
                accumulator <= 10'd0;
                count <= 2'd0;
                data_out <= 10'd0;
            end else if (state == ACCUMULATE) begin
                if (valid_in) begin
                    if (count == 2'd3) begin
                        // Output sum on 4th valid input and reset accumulator and count
                        accumulator <= 10'd0;
                        count <= 2'd0;
                        data_out <= sum_out;
                    end else begin
                        accumulator <= accumulator + data_in;
                        count <= count + 1'b1;
                    end
                end
                // If no valid_in, hold accumulator and count
            end
        end
    end

endmodule