module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Explicit state encoding
    reg [1:0] state;

    // State definitions
    localparam S0 = 2'b00;  // Initial state
    localparam S1 = 2'b01;  // Received '1'
    localparam S2 = 2'b10;  // Received '10'

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

    // Output is high when in S2 and receiving '1'
    assign z = (state == S2) & x;

endmodule