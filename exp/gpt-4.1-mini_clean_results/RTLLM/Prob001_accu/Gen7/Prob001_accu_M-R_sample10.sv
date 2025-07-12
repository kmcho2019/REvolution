module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    // States for FSM
    typedef enum logic [1:0] {
        IDLE        = 2'd0,
        ACCUMULATE  = 2'd1,
        OUTPUT      = 2'd2
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;

    // Next-state and output logic
    always @(*) begin
        next_state = state;
        valid_out  = 1'b0;
        data_out   = 10'd0;  // Default, valid_out=0 means data_out ignored

        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = ACCUMULATE;
            end

            ACCUMULATE: begin
                if (valid_in) begin
                    if (count == 2'd3) begin
                        // On 4th valid input, output sum next cycle
                        next_state = OUTPUT;
                    end
                end
            end

            OUTPUT: begin
                valid_out = 1'b1;
                data_out  = accumulator;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, accumulator and count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            accumulator <= 10'd0;
            count       <= 2'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        accumulator <= data_in;
                        count       <= 2'd1;
                    end else begin
                        accumulator <= 10'd0;
                        count       <= 2'd0;
                    end
                end

                ACCUMULATE: begin
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count       <= count + 1'b1;
                    end
                end

                OUTPUT: begin
                    accumulator <= 10'd0;
                    count       <= 2'd0;
                end
            endcase
        end
    end

endmodule