module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam IDLE = 3'b000;
    localparam S1   = 3'b001;
    localparam S2   = 3'b010;
    localparam S3   = 3'b011;
    localparam MATCH = 3'b100;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S2 : IDLE;
            S2:   next_state = data ? S2 : S3;
            S3:   next_state = data ? MATCH : IDLE;
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