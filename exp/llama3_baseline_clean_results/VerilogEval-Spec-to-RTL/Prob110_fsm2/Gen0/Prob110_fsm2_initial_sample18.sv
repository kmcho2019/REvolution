module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Define the states as OFF (0) and ON (1)
localparam OFF = 1'b0, ON = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF; // Asynchronous reset to OFF state
    end else begin
        case (state)
            OFF: begin
                if (j) state <= ON; // Transition from OFF to ON when j is 1
                else state <= OFF; // Stay in OFF when j is 0
            end
            ON: begin
                if (k) state <= OFF; // Transition from ON to OFF when k is 1
                else state <= ON; // Stay in ON when k is 0
            end
            default: state <= OFF; // Default state
        endcase
    end
end

always @(*) begin
    case (state)
        OFF: out = 0; // Output is 0 in the OFF state
        ON: out = 1; // Output is 1 in the ON state
        default: out = 0; // Default output
    endcase
end

endmodule