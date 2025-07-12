module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Using 1 bit for two states
reg [0:0] next_state;

// Define states
localparam OFF = 0;
localparam ON = 1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
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
        default: next_state = OFF; // Default state
    endcase
end

always @(*) begin
    case (state)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0; // Default output
    endcase
end

endmodule