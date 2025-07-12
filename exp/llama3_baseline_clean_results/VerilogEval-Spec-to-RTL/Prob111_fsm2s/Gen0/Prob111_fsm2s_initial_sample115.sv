module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Using a single bit for the two states

// Define the states
localparam OFF = 1'b0;
localparam ON = 1'b1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case(state)
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
            default: state <= OFF; // This should never happen
        endcase
    end
end

// Output is based on the state
always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0; // This should never happen
    endcase
end

endmodule