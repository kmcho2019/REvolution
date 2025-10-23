module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam [1:0]
        S0 = 2'b00,   // no match yet
        S1 = 2'b01,   // matched '1'
        S2 = 2'b10;   // matched "10"

    reg [1:0] state, next_state;
    reg next_z;

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

    always_comb begin
        // Default assignments
        next_state = S0;
        next_z = 1'b0;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1; // stay if input is '1'
                else
                    next_state = S2; // got "10"
            end
            S2: begin
                if (x) begin
                    next_state = S1; // "101" detected, go back to S1 for overlapping
                    next_z = 1'b1;   // output asserted here (Mealy behavior synchronized)
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

endmodule