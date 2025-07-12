module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [7:0] data_first; // Register to store the first 8-bit data input
reg       first_valid; // Flag to indicate if the first data is valid

// State machine states
typedef enum logic [1:0] {
    IDLE,
    WAIT_FOR_SECOND,
    OUTPUT
} state_t;

state_t state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= IDLE;
        data_first     <= 8'd0;
        first_valid    <= 1'b0;
        valid_out      <= 1'b0;
        data_out       <= 16'd0;
    end
    else begin
        state          <= next_state;
        case (next_state)
            WAIT_FOR_SECOND: begin
                data_first <= data_in;
                first_valid <= 1'b1;
            end
            OUTPUT: begin
                data_out  <= {data_first, data_in};
                valid_out <= 1'b1;
            end
            default: begin
                valid_out <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = WAIT_FOR_SECOND;
            end
            else begin
                next_state = IDLE;
            end
        end
        WAIT_FOR_SECOND: begin
            if (valid_in) begin
                next_state = OUTPUT;
            end
            else begin
                next_state = WAIT_FOR_SECOND;
            end
        end
        OUTPUT: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule