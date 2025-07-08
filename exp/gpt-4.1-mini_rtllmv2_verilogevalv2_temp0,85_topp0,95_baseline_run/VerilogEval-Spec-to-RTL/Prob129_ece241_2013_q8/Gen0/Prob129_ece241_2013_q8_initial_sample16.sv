module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00, // Initial state, no match
        S1 = 2'b01, // Detected '1'
        S2 = 2'b10  // Detected '10'
    } state_t;

    state_t state, next_state;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic (Mealy)
    always @(*) begin
        z = 1'b0; // default output
        case(state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    next_state = S2;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // "101" detected
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule