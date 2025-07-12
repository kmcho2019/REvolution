module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RECEIVE = 2'd1,
        STOP    = 2'd2,
        ERROR   = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Function to determine next state based on current state and input
    function state_t get_next_state(state_t curr_state, input logic bit_in, input [2:0] count);
        begin
            case (curr_state)
                IDLE:
                    get_next_state = (bit_in == 1'b0) ? RECEIVE : IDLE;
                RECEIVE:
                    get_next_state = (count == 3'd7) ? STOP : RECEIVE;
                STOP:
                    get_next_state = (bit_in == 1'b1) ? IDLE : ERROR;
                ERROR:
                    get_next_state = (bit_in == 1'b1) ? IDLE : ERROR;
                default:
                    get_next_state = IDLE;
            endcase
        end
    endfunction

    // Sequential state and data registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                end
                RECEIVE: begin
                    // Shift in LSB first: new bit at MSB, shift right
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end
                STOP, ERROR: begin
                    // Hold bit_count and data_reg values; no change needed
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = get_next_state(state, in, bit_count);
    end

    // done asserted high only for one cycle when STOP state has correct stop bit (in == 1)
    assign done = (state == STOP) && (in == 1'b1);

endmodule