module accu (
    input         clk,
    input         rst_n,
    input  [7:0]  data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

    // States for FSM
    typedef enum logic [1:0] {
        ACCUMULATE = 2'd0,
        OUTPUT     = 2'd1
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;
    reg [9:0] latched_data;
    reg       valid_out_reg;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= ACCUMULATE;
            accumulator <= 10'd0;
            count       <= 2'd0;
            latched_data <= 10'd0;
            valid_out_reg <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                ACCUMULATE: begin
                    valid_out_reg <= 1'b0;
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count <= count + 1'b1;
                    end
                end
                OUTPUT: begin
                    valid_out_reg <= 1'b1;
                    latched_data <= accumulator;
                    // Reset accumulator and count for next batch
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            ACCUMULATE: begin
                if (count == 2'd4)
                    next_state = OUTPUT;
            end
            OUTPUT: begin
                next_state = ACCUMULATE;
            end
        endcase
    end

    // Output assignments
    assign data_out = latched_data;
    assign valid_out = valid_out_reg;

endmodule