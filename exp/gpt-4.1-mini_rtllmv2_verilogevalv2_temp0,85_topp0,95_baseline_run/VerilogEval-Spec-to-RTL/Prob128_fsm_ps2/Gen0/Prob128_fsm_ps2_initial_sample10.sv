module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    // FSM state encoding
    localparam IDLE  = 2'd0,
               BYTE1 = 2'd1,
               BYTE2 = 2'd2,
               BYTE3 = 2'd3;

    reg [1:0] state, next_state;
    reg done_reg;

    // Output assignment
    assign done = done_reg;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if(in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = BYTE3;
            BYTE3: begin
                // After done, wait for next message start
                if(in[3] == 1'b1)
                    next_state = BYTE1;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if(reset) begin
            state    <= IDLE;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            // done asserted only on the cycle after BYTE3 received
            done_reg <= (state == BYTE3);
        end
    end

endmodule