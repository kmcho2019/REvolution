module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding (binary for area efficiency)
    localparam [2:0] IDLE  = 3'b000;
    localparam [2:0] S1    = 3'b001;
    localparam [2:0] S11   = 3'b010;
    localparam [2:0] S110  = 3'b011;
    localparam [2:0] FOUND = 3'b100;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = data ? S1 : IDLE;
            S1:    next_state = data ? S11 : IDLE;
            S11:   next_state = data ? S11 : S110;
            S110:  next_state = data ? FOUND : IDLE;
            FOUND: next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else if (state != FOUND) begin
            state <= next_state;
        end
    end

    assign start_shifting = (state == FOUND);

endmodule