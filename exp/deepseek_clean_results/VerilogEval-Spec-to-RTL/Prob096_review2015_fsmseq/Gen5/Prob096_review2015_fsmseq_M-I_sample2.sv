module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Binary encoded states (2 bits for 4 states)
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] GOT1  = 2'b01;
    localparam [1:0] GOT11 = 2'b10;
    localparam [1:0] FOUND = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            // Registered output (better timing)
            start_shifting <= (next_state == FOUND);
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? FOUND : GOT1;
            FOUND:  next_state = FOUND;
        endcase
    end

endmodule