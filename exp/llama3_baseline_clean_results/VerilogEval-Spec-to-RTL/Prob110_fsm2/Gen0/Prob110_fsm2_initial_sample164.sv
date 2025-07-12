module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state = 1'b0; // Initialize state to OFF (0)
reg [1:0] next_state; // Next state variable

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset to OFF state
        state <= OFF;
    end else begin
        case (state)
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
            default: state <= OFF; // Default to OFF state
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
        default: out <= 1'b0; // Default output to 0
    endcase
end

endmodule