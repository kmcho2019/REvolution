module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot encoded states
    localparam IDLE  = 3'b001;
    localparam BYTE2 = 3'b010;
    localparam BYTE3 = 3'b100;

    reg [2:0] state, next_state;
    reg [23:0] msg_buffer;
    reg done_reg;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_buffer <= 24'b0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= (state == BYTE3);
            
            // Only update buffer when receiving a valid byte
            if (state == IDLE && in[3]) begin
                msg_buffer <= {16'b0, in};
            end else if (state == BYTE2) begin
                msg_buffer <= {msg_buffer[15:0], in};
            end else if (state == BYTE3) begin
                msg_buffer <= {msg_buffer[7:0], in};
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = in[3] ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign done = done_reg;
    assign out_bytes = msg_buffer;

endmodule