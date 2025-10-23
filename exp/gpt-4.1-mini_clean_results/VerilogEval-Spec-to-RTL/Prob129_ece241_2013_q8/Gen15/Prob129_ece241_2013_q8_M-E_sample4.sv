module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding: 3 bits, only one high at a time
    // IDLE = 3'b001, STATE_1 = 3'b010, STATE_10 = 3'b100
    localparam IDLE    = 3'b001;
    localparam STATE_1 = 3'b010;
    localparam STATE_10= 3'b100;

    reg [2:0] state, next_state;

    // Next state and output logic combined (Mealy)
    always @(*) begin
        // Default assignments
        next_state = IDLE;
        z = 1'b0;

        case (state)
            IDLE: begin
                if (x) 
                    next_state = STATE_1;
                else
                    next_state = IDLE;
            end
            STATE_1: begin
                if (x)
                    next_state = STATE_1;
                else
                    next_state = STATE_10;
            end
            STATE_10: begin
                if (x) begin
                    next_state = STATE_1;
                    z = 1'b1; // "101" detected at this input
                end else
                    next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
                z = 1'b0;
            end
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule