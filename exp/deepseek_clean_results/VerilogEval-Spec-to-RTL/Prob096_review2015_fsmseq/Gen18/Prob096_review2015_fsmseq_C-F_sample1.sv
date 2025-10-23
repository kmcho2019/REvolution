module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam GOT1   = 2'b01;
    localparam GOT11  = 2'b10;
    localparam GOT110 = 2'b11;

    reg [1:0] state, next_state;
    reg found;

    // State transition logic
    always @(*) begin
        if (found) begin
            next_state = state;  // Freeze state when sequence found
        end else begin
            case (state)
                IDLE:   next_state = data ? GOT1 : IDLE;
                GOT1:   next_state = data ? GOT11 : IDLE;
                GOT11:  next_state = data ? GOT11 : GOT110;
                GOT110: next_state = data ? GOT1 : IDLE;
                default: next_state = IDLE;
            endcase
        end
    end

    // Sequence detection and state update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            found <= 1'b0;
        end else begin
            state <= next_state;
            if (!found) begin
                found <= (state == GOT110) && data;
            end
        end
    end

    assign start_shifting = found;

endmodule