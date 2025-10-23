module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding (using 2 bits for clarity)
    localparam [1:0]
        S0 = 2'd0, // no bits matched
        S1 = 2'd1, // matched '1'
        S2 = 2'd2; // matched "10"

    reg [1:0] current_state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        // Default output and next state
        z = 1'b0;
        next_state = S0;

        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end

            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // sequence "101" detected
                end else
                    next_state = S0;
            end

            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

endmodule