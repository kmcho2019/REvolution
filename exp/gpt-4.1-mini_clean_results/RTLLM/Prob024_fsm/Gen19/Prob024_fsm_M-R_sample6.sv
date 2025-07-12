module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary):
    localparam S0 = 3'b000; // no bits matched
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '10'
    localparam S3 = 3'b011; // matched '100'
    localparam S4 = 3'b100; // matched '1001'

    reg [2:0] state, next_state;

    // Sequential logic: state register with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S2;
            end
            default: next_state = S0;
        endcase
    end

    // Mealy output logic: MATCH asserted when full sequence "10011" detected
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule