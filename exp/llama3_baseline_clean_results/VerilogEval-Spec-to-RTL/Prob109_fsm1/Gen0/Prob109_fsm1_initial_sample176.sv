module TopModule(
    input       clk,
    input       areset,
    input       in,
    output      out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state

// State encoding: A = 0, B = 1

always @(*) begin
    case(state)
        0: begin // State A
            if(in)
                next_state = 0; // A --1--> A
            else
                next_state = 1; // A --0--> B
        end
        1: begin // State B
            if(in)
                next_state = 1; // B --1--> B
            else
                next_state = 0; // B --0--> A
        end
        default: next_state = 1; // Default to state B
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Moore machine output is determined solely by the current state
assign out = (state == 0) ? 0 : 1; // Output based on state

endmodule