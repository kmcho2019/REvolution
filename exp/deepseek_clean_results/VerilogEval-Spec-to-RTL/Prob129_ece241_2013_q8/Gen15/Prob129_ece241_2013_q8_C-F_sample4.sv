module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State encoding
    localparam S0 = 2'b00;  // Initial state, no pattern detected
    localparam S1 = 2'b01;  // Detected '1'
    localparam S2 = 2'b10;  // Detected '10'

    reg [1:0] state;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S1 : S2;
                S2: state <= x ? S1 : S0;
                default: state <= S0;
            endcase
        end
    end

    // Mealy output - depends on current state and input
    assign z = (state == S2) & x;

endmodule