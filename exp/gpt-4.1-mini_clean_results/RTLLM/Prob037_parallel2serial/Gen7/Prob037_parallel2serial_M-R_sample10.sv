module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    // FSM states
    typedef enum logic [0:0] {
        LOAD  = 1'b0,
        SHIFT = 1'b1
    } state_t;

    state_t state, next_state;
    reg [3:0] shift_reg;
    reg [1:0] cnt;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= LOAD;
            shift_reg <= 4'd0;
            cnt       <= 2'd0;
        end else begin
            state <= next_state;
            if (state == LOAD) begin
                shift_reg <= d;
                cnt       <= 2'd0;
            end else begin // SHIFT
                shift_reg <= {shift_reg[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            LOAD:  next_state = SHIFT;
            SHIFT: next_state = (cnt == 2'd3) ? LOAD : SHIFT;
            default: next_state = LOAD;
        endcase
    end

    // Outputs driven combinationally
    assign dout      = shift_reg[3];
    assign valid_out = (state == LOAD);

endmodule