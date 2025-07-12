module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        ACCUMULATE = 2'b01
    } state_t;

    state_t state, next_state;

    reg [9:0] accumulator;
    reg [2:0] count; // up to 4 inputs, 3 bits are safe

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Start accumulating when valid_in asserted
                if (valid_in)
                    next_state = ACCUMULATE;
                else
                    next_state = IDLE;
            end
            ACCUMULATE: begin
                if (count == 3'd4)
                    next_state = IDLE;
                else
                    next_state = ACCUMULATE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Accumulation and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'd0;
            count <= 3'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default zero

            case (state)
                IDLE: begin
                    accumulator <= 10'd0;
                    count <= 3'd0;
                    if (valid_in) begin
                        accumulator <= data_in;
                        count <= 3'd1;
                    end
                end
                ACCUMULATE: begin
                    if (valid_in && count < 3'd4) begin
                        accumulator <= accumulator + data_in;
                        count <= count + 1'b1;
                    end

                    if (count == 3'd4) begin
                        data_out <= accumulator;
                        valid_out <= 1'b1;
                    end
                end
                default: ;
            endcase
        end
    end

endmodule