module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Declare a 2-bit signal 'state' to represent the current state
localparam OFF = 1'b0; // Define the OFF state
localparam ON  = 1'b1; // Define the ON state

always @(posedge clk) begin
    if (reset) begin // If reset is high, go to the OFF state
        state <= OFF;
    end else begin
        case (state) // Determine the next state based on the current state and input values
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF; // Default to the OFF state if the current state is invalid
        endcase
    end
end

always @(*) begin // Use a combinational logic block to assign the output 'out' based on the current state
    case (state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0; // Default to 0 if the current state is invalid
    endcase
end

endmodule