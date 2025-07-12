module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
localparam B = 1'b0, A = 1'b1;
reg current_state, next_state;

// Output is determined by the current state
always @(*) begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'bx;
    endcase
end

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        current_state <= B;
    end else begin
        case(current_state)
            B: if(!in) current_state <= A; else current_state <= B;
            A: if(!in) current_state <= B; else current_state <= A;
            default: current_state <= B;
        endcase
    end
end

endmodule