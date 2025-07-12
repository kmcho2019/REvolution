module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding (2 bits for 4 states)
    localparam IDLE  = 2'b00;
    localparam S1    = 2'b01;
    localparam S2    = 2'b10;
    localparam MATCH = 2'b11;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = data ? S1 : IDLE;
            S1:    next_state = data ? S2 : IDLE;
            S2:    next_state = data ? S2 : (data ? MATCH : IDLE);
            MATCH: next_state = MATCH;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign start_shifting = (state == MATCH);

endmodule