module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding using localparam for synthesis friendliness
    localparam S0 = 2'b00; // no bits matched
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '10'

    reg [1:0] state, next_state;

    // Sequential logic: state update with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state and Mealy output z generation
    always @(*) begin
        // Default assignments
        next_state = S0;
        z = 1'b0;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (!x)
                    next_state = S2;
                else
                    next_state = S1;
            end

            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // sequence '101' detected here
                end else
                    next_state = S0;
            end

            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule