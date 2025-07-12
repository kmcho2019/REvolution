module TopModule (
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding (one-hot style different from previous binary)
    localparam S0 = 2'b00; // no match
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '10'

    reg [1:0] state, next_state;
    reg       next_z;

    // Combinational logic for next state and output
    always @(*) begin
        next_state = S0;
        next_z     = 1'b0;

        case (state)
            S0: begin
                if (x == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (x == 1'b1) begin
                    next_state = S1;
                    next_z     = 1'b1; // "101" detected here
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
                next_z     = 1'b0;
            end
        endcase
    end

    // State and output registers, async negedge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z     <= 1'b0;
        end else begin
            state <= next_state;
            z     <= next_z;
        end
    end

endmodule