module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        ACCUMULATE = 2'd1,
        OUTPUT     = 2'd2
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;

    // Next value combinational logic
    wire [9:0] acc_next = accumulator + data_in;
    wire [1:0] count_next = count + 1'b1;

    // State transition combinational logic
    always @(*) begin
        valid_out = 1'b0;
        data_out = 10'd0;
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state = ACCUMULATE;
                end
            end
            ACCUMULATE: begin
                if (valid_in && count == 2'd3) begin
                    next_state = OUTPUT;
                end
            end
            OUTPUT: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            accumulator <= 10'd0;
            count       <= 2'd0;
            valid_out   <= 1'b0;
            data_out    <= 10'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    data_out  <= 10'd0;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                    if (valid_in) begin
                        accumulator <= data_in;
                        count <= 2'd1;
                    end
                end
                ACCUMULATE: begin
                    valid_out <= 1'b0;
                    data_out <= 10'd0;
                    if (valid_in) begin
                        if (count == 2'd3) begin
                            // This case will transition to OUTPUT next cycle
                        end else begin
                            accumulator <= acc_next;
                            count <= count_next;
                        end
                    end
                end
                OUTPUT: begin
                    valid_out <= 1'b1;
                    data_out <= accumulator + data_in; // sum of 4 inputs
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
                default: begin
                    valid_out <= 1'b0;
                    data_out  <= 10'd0;
                end
            endcase
        end
    end

endmodule