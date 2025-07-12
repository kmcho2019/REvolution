module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10
    } state_t;

    state_t current_state, next_state;

    // Next state and output logic (combinational)
    always @(*) begin
        // Default values
        next_state = current_state;
        z = 1'b0;

        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                z = 1'b0;
            end
            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
                z = 1'b0;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // "101" sequence detected
                end else begin
                    next_state = S0;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

endmodule