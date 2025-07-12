module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // Using a single bit for two states: 0 - OFF, 1 - ON
reg [0:0] next_state;

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF; // Default to OFF state
    endcase
end

always @(*) begin
    case (state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0; // Default output to 0
    endcase
end

endmodule