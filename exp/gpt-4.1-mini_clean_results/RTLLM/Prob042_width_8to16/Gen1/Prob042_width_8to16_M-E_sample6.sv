module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        WAIT_FIRST = 2'b00,
        WAIT_SECOND = 2'b01
    } state_t;

    state_t state, next_state;
    reg [7:0] first_byte;
    reg valid_out_next;
    reg [15:0] data_out_next;

    // FSM state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WAIT_FIRST;
        end else begin
            state <= next_state;
        end
    end

    // Data and output registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_byte  <= 8'b0;
            valid_out   <= 1'b0;
            data_out    <= 16'b0;
        end else begin
            valid_out <= valid_out_next;
            data_out  <= data_out_next;
            if (state == WAIT_FIRST && valid_in) begin
                first_byte <= data_in; // latch first byte
            end
        end
    end

    // Next state logic and output combinational logic
    always @(*) begin
        // Default assignments
        next_state      = state;
        valid_out_next  = 1'b0;
        data_out_next   = 16'b0;

        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                    // No output yet: waiting for second input
                end
            end
            WAIT_SECOND: begin
                if (valid_in) begin
                    // Second valid data arrives: output next cycle
                    data_out_next  = {first_byte, data_in};
                    valid_out_next = 1'b1;
                    next_state     = WAIT_FIRST;
                end else begin
                    // Stay waiting for second valid input
                    next_state = WAIT_SECOND;
                end
            end
            default: begin
                next_state = WAIT_FIRST;
            end
        endcase
    end

endmodule