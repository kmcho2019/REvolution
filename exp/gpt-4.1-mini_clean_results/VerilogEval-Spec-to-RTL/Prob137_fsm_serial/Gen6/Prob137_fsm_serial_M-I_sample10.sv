module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // Gray encoded FSM states (2 bits)
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b11;
    localparam ERROR   = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
        end else begin
            state <= next_state;

            if (state == IDLE)
                bit_count <= 3'd0;
            else if (state == RECEIVE)
                bit_count <= bit_count + 1'b1;

            if (state == RECEIVE)
                data_reg <= {in, data_reg[7:1]};
        end
    end

    // done is a combinational pulse: high only when stop bit is correct and FSM is in STOP state
    assign done = (state == STOP) && (in == 1'b1);

endmodule