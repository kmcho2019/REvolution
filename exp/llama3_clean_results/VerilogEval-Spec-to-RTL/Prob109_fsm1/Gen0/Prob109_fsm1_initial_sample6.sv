module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg [0:0] state; // current state (0 for A, 1 for B)
reg [0:0] next_state; // next state

// Combinational process to determine the next state
always @(*) begin
    case(state)
        1'b0: // State A
            case(in)
                1'b0: next_state = 1'b1; // A --0--> B
                1'b1: next_state = 1'b0; // A --1--> A
                default: next_state = 1'b0;
            endcase
        1'b1: // State B
            case(in)
                1'b0: next_state = 1'b0; // B --0--> A
                1'b1: next_state = 1'b1; // B --1--> B
                default: next_state = 1'b1;
            endcase
        default: next_state = 1'b1;
    endcase
end

// Sequential process to update the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        state <= next_state; // update state on clock edge
    end
end

// Assign output based on the current state
assign out = state;

endmodule