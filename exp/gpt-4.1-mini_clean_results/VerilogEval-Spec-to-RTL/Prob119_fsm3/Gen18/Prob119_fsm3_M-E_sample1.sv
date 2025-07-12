module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // One-hot state encoding (4 bits for 4 states)
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;

    // Combine state update and output logic in single always block with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            // Output depends only on next state since this is Moore FSM
            // However, output changes on state transitions, so register output here
            out <= (next_state == D);
        end
    end

    // Combinational logic for next state based on current state and input
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Safety default
        endcase
    end

endmodule