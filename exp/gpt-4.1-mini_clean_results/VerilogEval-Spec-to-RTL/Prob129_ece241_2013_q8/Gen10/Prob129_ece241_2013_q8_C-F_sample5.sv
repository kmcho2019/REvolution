module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparams for clarity and synthesis friendliness
    localparam S_IDLE = 2'd0; // no bits matched yet, waiting for '1'
    localparam S_1    = 2'd1; // matched '1'
    localparam S_10   = 2'd2; // matched "10"

    reg [1:0] state, next_state;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Combined next state and output logic (combinational)
    always @(*) begin
        next_state = state;
        z = 1'b0;

        case (state)
            S_IDLE: begin
                if (x)
                    next_state = S_1;
                else
                    next_state = S_IDLE;
                z = 1'b0;
            end

            S_1: begin
                if (~x)
                    next_state = S_10;
                else
                    next_state = S_1;
                z = 1'b0;
            end

            S_10: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b1; // sequence "101" detected
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

endmodule