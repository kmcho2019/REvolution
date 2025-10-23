module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Gray code state encoding (single bit changes between states)
    parameter IDLE  = 2'b00;
    parameter GOT1  = 2'b01;
    parameter GOT10 = 2'b11;  // Gray code sequence: 00->01->11->00

    reg [1:0] state, next_state;
    reg x_prev;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = x ? GOT1 : IDLE;
            GOT1:  next_state = x ? GOT1 : GOT10;
            GOT10: next_state = x ? GOT1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register with clock gating when input doesn't change
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            x_prev <= 1'b0;
        end else if (x != x_prev) begin
            state <= next_state;
            x_prev <= x;
        end
    end

    // Registered Mealy output
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            z <= 1'b0;
        end else begin
            z <= (state == GOT10) & x;
        end
    end

endmodule