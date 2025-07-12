module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State encoding: 3 states for sequence "101"
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    reg [1:0] state, next_state;
    reg next_z;

    // Next state and output logic
    always @(*) begin
        next_state = state;
        next_z = 1'b0;  // default no output

        case(state)
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
                    next_z = 1'b1;  // sequence detected
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Generate clock enable to update state and output only when needed
    wire clk_en = (state != next_state) || (z != next_z);

    // State and output registers with async negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else if (clk_en) begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule