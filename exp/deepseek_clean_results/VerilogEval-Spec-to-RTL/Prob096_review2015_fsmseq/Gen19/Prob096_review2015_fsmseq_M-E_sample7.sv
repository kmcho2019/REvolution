module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // States encoding
    localparam [1:0] IDLE    = 2'b00;
    localparam [1:0] GOT_1   = 2'b01;
    localparam [1:0] GOT_11  = 2'b10;
    localparam [1:0] GOT_110 = 2'b11;

    reg [1:0] current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            // Output is registered for better timing
            if (next_state == GOT_110 && data)
                start_shifting <= 1'b1;
        end
    end

    always @(*) begin
        case (current_state)
            IDLE:    next_state = data ? GOT_1 : IDLE;
            GOT_1:   next_state = data ? GOT_11 : IDLE;
            GOT_11:  next_state = data ? GOT_11 : GOT_110;
            GOT_110: next_state = data ? (start_shifting ? GOT_110 : GOT_1) : IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule