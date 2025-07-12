module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam IDLE     = 3'b000;
    localparam GOT_1    = 3'b001;
    localparam GOT_11   = 3'b010;
    localparam GOT_110  = 3'b011;
    localparam FOUND    = 3'b100;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE:    next_state = data ? GOT_1 : IDLE;
            GOT_1:   next_state = data ? GOT_11 : IDLE;
            GOT_11:  next_state = data ? GOT_11 : GOT_110;
            GOT_110: next_state = data ? FOUND : IDLE;
            FOUND:   next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    assign start_shifting = (current_state == FOUND);

endmodule