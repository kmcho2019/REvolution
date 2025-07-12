module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // Define states
    parameter IDLE = 2'b00;
    parameter GOT1 = 2'b01;
    parameter GOT11 = 2'b10;
    parameter GOT110 = 2'b11;

    reg [1:0] state, next_state;
    reg found;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? GOT11 : GOT110;
            GOT110: next_state = data ? IDLE : IDLE; // Reset on success
            default: next_state = IDLE;
        endcase
    end

    // State register and found flag
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found <= 1'b0;
        end else if (!found) begin
            state <= next_state;
            found <= (state == GOT110) && data;
        end
    end

    assign start_shifting = found;

endmodule