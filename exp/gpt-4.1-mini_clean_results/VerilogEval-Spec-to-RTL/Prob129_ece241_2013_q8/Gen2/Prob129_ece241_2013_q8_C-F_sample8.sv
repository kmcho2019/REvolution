module TopModule(
    input  wire clk,
    input  wire aresetn,
    input  wire x,
    output reg  z
);

    // State encoding (3 states)
    localparam S0 = 2'b00; // no match yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched '10'

    reg [1:0] state, next_state;

    // Next state and output logic combined (combinational)
    always @(*) begin
        next_state = S0; // default state
        z = 1'b0;        // default output

        case (state)
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

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule