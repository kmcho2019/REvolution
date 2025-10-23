module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Define the state register
reg [1:0] state;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the state on asynchronous reset
        state <= S0;
    end else begin
        // State transition logic
        case (state)
            S0: state <= x ? S1 : S0;
            S1: state <= x ? S2 : S0;
            S2: state <= x ? S2 : S0;
            default: state <= S0;
        endcase
    end
end

// Output logic: Assert z when the state is S2 and the current input is "1"
assign z = (state == S2) && x;

endmodule