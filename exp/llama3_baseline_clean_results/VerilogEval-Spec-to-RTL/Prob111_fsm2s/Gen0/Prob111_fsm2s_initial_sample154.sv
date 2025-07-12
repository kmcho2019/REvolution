module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state, next_state;

// Define states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Output Logic
always @(state) begin
    case(state)
        OFF: out <= 1'b0;
        ON:  out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

// State Register
always @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Next State Logic
always @(state, j, k) begin
    case(state)
        OFF: begin
            if (j) begin
                next_state <= ON;
            end else begin
                next_state <= OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state <= OFF;
            end else begin
                next_state <= ON;
            end
        end
        default: next_state <= OFF;
    endcase
end

endmodule