module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
    );

    reg [1:0] state; // Current state
    reg [1:0] next_state; // Next state

    // State definitions
    parameter OFF = 0, ON = 1;

    // Combinational logic for next state
    always @(*) begin
        case(state)
            OFF: begin
                if(j == 1) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if(k == 1) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
        endcase
    end

    // Sequential logic for state update
    always_ff @(posedge clk) begin
        if(reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        case(state)
            OFF: out = 0;
            ON:  out = 1;
        endcase
    end

endmodule