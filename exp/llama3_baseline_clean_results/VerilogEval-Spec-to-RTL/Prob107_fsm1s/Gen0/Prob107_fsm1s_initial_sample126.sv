module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // using 2 bits to represent two states

// Define the states
localparam A = 1'b0;
localparam B = 1'b1;

// Output logic
always @(state)
begin
    case(state)
        A: out <= 1'b0;
        B: out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

// State transition logic
always @(posedge clk)
begin
    if (reset) begin // Active-high synchronous reset
        state <= B;
    end else begin
        case(state)
            A: begin
                if (!in) begin
                    state <= B;
                end
            end
            B: begin
                if (!in) begin
                    state <= A;
                end
            end
            default: state <= B; // default to reset state
        endcase
    end
end

initial begin
    state <= B; // initial state
end

endmodule