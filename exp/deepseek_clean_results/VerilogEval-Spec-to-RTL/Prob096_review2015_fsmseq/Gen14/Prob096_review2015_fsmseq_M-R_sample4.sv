module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States for sequence detection
    localparam IDLE  = 3'b000;
    localparam S1    = 3'b001;
    localparam S11   = 3'b011;
    localparam S110  = 3'b010;
    localparam FOUND = 3'b110;

    reg [2:0] state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
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

    // Output logic
    assign start_shifting = (state == FOUND);

endmodule