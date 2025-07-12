module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // Gray code state encoding for 3 states (2 bits)
    localparam [1:0] 
        S_IDLE = 2'b00,  // no bits matched yet
        S_1    = 2'b01,  // matched first '1'
        S_10   = 2'b11;  // matched "10"
    // Note: one state code (2'b10) unused

    reg [1:0] state, next_state;

    // Next state and output logic combined in a case statement for clarity
    always @(*) begin
        case(state)
            S_IDLE: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b0;
                end else begin
                    next_state = S_IDLE;
                    z = 1'b0;
                end
            end

            S_1: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b0;
                end else begin
                    next_state = S_10;
                    z = 1'b0;
                end
            end

            S_10: begin
                if (x) begin
                    next_state = S_1;
                    // Sequence "101" detected when in S_10 and input x==1
                    z = 1'b1;
                end else begin
                    next_state = S_IDLE;
                    z = 1'b0;
                end
            end

            default: begin
                next_state = S_IDLE;
                z = 1'b0;
            end
        endcase
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule