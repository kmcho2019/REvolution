module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states as parameters
    parameter IDLE   = 3'b000;
    parameter GOT1   = 3'b001;
    parameter GOT11  = 3'b010;
    parameter GOT110 = 3'b011;
    parameter FOUND  = 3'b100;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? GOT11 : GOT110;
            GOT110: next_state = data ? FOUND : IDLE;
            FOUND:  next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            start_shifting <= 1'b0;
        end else begin
            start_shifting <= (next_state == FOUND);
        end
    end

endmodule