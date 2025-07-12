module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding for 3 states to simplify logic:
    // Each state is a single bit in a 3-bit register.
    localparam S_IDLE = 3'b001; // no bits matched yet, waiting for '1'
    localparam S_1    = 3'b010; // matched '1'
    localparam S_10   = 3'b100; // matched "10"

    reg [2:0] state, next_state;

    // Next state and output logic combined (combinational)
    always @(*) begin
        // Defaults
        next_state = 3'b000;
        z = 1'b0;

        case (state)
            S_IDLE: begin
                if (x) next_state = S_1;
                else next_state = S_IDLE;
            end
            S_1: begin
                if (x) next_state = S_1;
                else next_state = S_10;
            end
            S_10: begin
                if (x) begin
                    next_state = S_1;
                    z = 1'b1; // Output asserted when "101" sequence detected on 'x' == 1 in S_10
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