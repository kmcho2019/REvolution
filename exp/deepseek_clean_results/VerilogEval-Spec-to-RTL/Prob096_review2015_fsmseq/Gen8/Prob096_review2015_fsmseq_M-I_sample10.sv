module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam S_IDLE  = 4'b0001;
    localparam S_1     = 4'b0010;
    localparam S_11    = 4'b0100;
    localparam S_110   = 4'b1000;
    localparam S_DONE  = 4'b0000; // Special case for done state
    
    reg [3:0] state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            state <= next_state;
            start_shifting <= (next_state == S_DONE);
        end
    end

    always @(*) begin
        case (state)
            S_IDLE: next_state = data ? S_1 : S_IDLE;
            S_1:    next_state = data ? S_11 : S_IDLE;
            S_11:   next_state = data ? S_11 : S_110;
            S_110:  next_state = data ? S_DONE : S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

endmodule