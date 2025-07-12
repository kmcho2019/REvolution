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
        IDLE = 2'b00,
        ACCUMULATE = 2'b01
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;
    reg [9:0] output_reg;

    wire [9:0] acc_plus_in = accumulator + data_in;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = ACCUMULATE;
                else
                    next_state = IDLE;
            end
            ACCUMULATE: begin
                if (valid_in && (count == 2'd3))
                    next_state = IDLE;
                else
                    next_state = ACCUMULATE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            accumulator<= 10'd0;
            count      <= 2'd0;
            valid_out  <= 1'b0;
            data_out   <= 10'd0;
            output_reg <= 10'd0;
        end else begin
            state <= next_state;
            valid_out <= 1'b0; // default output pulse low

            case (state)
                IDLE: begin
                    accumulator <= 10'd0;
                    count <= 2'd0;
                    if (valid_in) begin
                        accumulator <= data_in;
                        count <= 2'd1;
                    end
                end
                ACCUMULATE: begin
                    if (valid_in) begin
                        accumulator <= acc_plus_in;
                        if (count == 2'd3) begin
                            output_reg <= acc_plus_in;
                            valid_out <= 1'b1;
                            count <= 2'd0;
                            accumulator <= 10'd0;
                        end else begin
                            count <= count + 1'b1;
                        end
                    end
                end
                default: ;
            endcase

            // Update data_out at output event
            if (valid_out)
                data_out <= output_reg;
        end
    end

endmodule