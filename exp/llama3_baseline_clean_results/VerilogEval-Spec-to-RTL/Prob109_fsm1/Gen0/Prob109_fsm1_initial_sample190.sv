module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // current state
reg [0:0] next_state; // next state

// asynchronous reset
always @(areset or posedge clk) begin
    if (areset) begin
        state <= 1'b1; // reset to state B
    end else begin
        state <= next_state;
    end
end

// next state logic
always @(*) begin
    case (state)
        1'b0: // state A
            if (~in) begin
                next_state = 1'b1; // A (0) --0--> B
            end else begin
                next_state = 1'b0; // A (0) --1--> A
            end
        1'b1: // state B
            if (~in) begin
                next_state = 1'b0; // B (1) --0--> A
            end else begin
                next_state = 1'b1; // B (1) --1--> B
            end
        default:
            next_state = 1'b1;
    endcase
end

// output logic
assign out = state;

endmodule