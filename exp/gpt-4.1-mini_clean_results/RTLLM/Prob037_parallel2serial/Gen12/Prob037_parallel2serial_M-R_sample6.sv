module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01
    } state_t;

    state_t state, next_state;
    reg [3:0] data_reg;
    reg [1:0] cnt;

    // State and data register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            data_reg  <= 4'd0;
            cnt       <= 2'd0;
            dout      <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    data_reg  <= d;
                    dout      <= d[3];
                    cnt       <= 2'd0;
                    valid_out <= 1'b1;
                end
                SHIFT: begin
                    data_reg <= {data_reg[2:0], 1'b0}; // shift left
                    dout     <= data_reg[2]; // next MSB after shift
                    cnt      <= cnt + 1'b1;
                    valid_out <= 1'b0;
                end
                default: begin
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = SHIFT;
            SHIFT: next_state = (cnt == 2'd3) ? IDLE : SHIFT;
            default: next_state = IDLE;
        endcase
    end

endmodule