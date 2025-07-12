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
        ACCUMULATE = 2'b00,
        OUTPUT     = 2'b01
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [1:0] count;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= ACCUMULATE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            ACCUMULATE: begin
                if (valid_in && (count == 2'd3))
                    next_state = OUTPUT;
                else
                    next_state = ACCUMULATE;
            end
            OUTPUT: begin
                next_state = ACCUMULATE;
            end
            default: next_state = ACCUMULATE;
        endcase
    end

    // Output and accumulator logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 2'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;  // Default

            case (state)
                ACCUMULATE: begin
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count <= count + 1'b1;
                    end
                end
                OUTPUT: begin
                    data_out <= accumulator;
                    valid_out <= 1'b1;
                    accumulator <= 10'd0;
                    count <= 2'd0;
                end
            endcase
        end
    end

endmodule