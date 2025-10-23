module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output reg      valid_out,
    output reg [9:0] data_out
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        ACCUM = 2'b01,
        OUTPUT = 2'b10
    } state_t;

    state_t state, next_state;
    reg [9:0] accumulator;
    reg [1:0] input_count; // counts 0 to 3 inputs accumulated

    // State transition and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            accumulator <= 10'd0;
            input_count <= 2'd0;
            data_out    <= 10'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    valid_out <= 1'b0;
                    accumulator <= 10'd0;
                    input_count <= 2'd0;
                    if (valid_in) begin
                        accumulator <= data_in;
                        input_count <= 2'd1;
                    end
                end
                ACCUM: begin
                    valid_out <= 1'b0;
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        input_count <= input_count + 1'b1;
                    end
                end
                OUTPUT: begin
                    valid_out <= 1'b1;
                    data_out <= accumulator;
                end
                default: begin
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = (input_count == 2'd3) ? OUTPUT : ACCUM;
            end
            ACCUM: begin
                if (input_count == 2'd4)
                    next_state = OUTPUT;
                else
                    next_state = ACCUM;
            end
            OUTPUT: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule