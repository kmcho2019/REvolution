module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states as enums
enum logic [1:0] {A, B, C, D} state, next_state;

// Synchronized reset
reg reset_sync;
always @(posedge clk) reset_sync <= areset;

// State machine
always @(posedge clk) begin
    if (reset_sync) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
            default: state <= A; // default state
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    case (state)
        A, B, C: out <= 0;
        D: out <= 1;
        default: out <= 0; // default output
    endcase
end

endmodule