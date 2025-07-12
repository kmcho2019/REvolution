module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // State parameters
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam WAIT_STOP = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg done_reg;

    // Continuous assignments
    assign done = done_reg;

    // FSM state transition (combinational)
    assign next_state = 
        (state == IDLE)    ? (in ? IDLE : RECEIVE) :
        (state == RECEIVE) ? (bit_count == 3'd7 ? WAIT_STOP : RECEIVE) :
        (state == WAIT_STOP) ? (in ? IDLE : WAIT_STOP) :
        IDLE; // default

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0;

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (!in) begin
                        shift_reg <= 0;
                    end
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                WAIT_STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        done_reg <= 1;
                    end
                end
            endcase
        end
    end

endmodule