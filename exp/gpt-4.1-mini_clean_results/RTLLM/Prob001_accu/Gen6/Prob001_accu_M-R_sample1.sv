module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    typedef enum logic [1:0] {
        ACCUMULATE = 2'b00,
        OUTPUT     = 2'b01
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [2:0] count; // 3 bits to count up to 4

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= ACCUMULATE;
        else
            state <= next_state;
    end

    // Next state logic and outputs
    always @(*) begin
        next_state = state;
        valid_out = 1'b0;
        case (state)
            ACCUMULATE: begin
                if (count == 3'd4)
                    next_state = OUTPUT;
            end
            OUTPUT: begin
                // valid_out pulse happens in OUTPUT state only for one cycle
                valid_out = 1'b1;
                next_state = ACCUMULATE;
            end
            default: next_state = ACCUMULATE;
        endcase
    end

    // Accumulator and count logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 3'd0;
            data_out <= 10'd0;
        end else begin
            case (state)
                ACCUMULATE: begin
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        count <= count + 1'b1;
                    end
                end
                OUTPUT: begin
                    data_out <= accumulator;
                    accumulator <= 10'd0;
                    count <= 3'd0;
                end
                default: begin
                    accumulator <= 10'd0;
                    count <= 3'd0;
                end
            endcase
        end
    end

endmodule