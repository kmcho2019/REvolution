module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        ACCUMULATE = 2'b01
    } state_t;

    state_t state, next_state;
    reg [9:0] accumulator;
    reg [1:0] count;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = valid_in ? ACCUMULATE : IDLE;
            ACCUMULATE:
                next_state = (count == 2'd3 && valid_in) ? IDLE : ACCUMULATE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            accumulator<= 10'd0;
            count      <= 2'd0;
            data_out   <= 10'd0;
            valid_out  <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= 1'b0;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        accumulator <= data_in;
                        count <= 2'd1;
                    end else begin
                        accumulator <= 10'd0;
                        count <= 2'd0;
                    end
                end

                ACCUMULATE: begin
                    if (valid_in) begin
                        if (count == 2'd3) begin
                            // Output the accumulated sum including the current data_in
                            data_out <= accumulator + data_in;
                            valid_out <= 1'b1;
                            accumulator <= 10'd0;
                            count <= 2'd0;
                        end else begin
                            accumulator <= accumulator + data_in;
                            count <= count + 1'b1;
                        end
                    end
                end

                default: begin
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            endcase
        end
    end

endmodule