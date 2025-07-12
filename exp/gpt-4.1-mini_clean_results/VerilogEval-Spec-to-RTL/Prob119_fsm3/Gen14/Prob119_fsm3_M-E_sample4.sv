module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot state encoding: A=0001, B=0010, C=0100, D=1000
    reg [3:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        // Default no state active
        next_state = 4'b0000;

        case (1'b1)  // priority encoding based on current state bits
            state[0]: next_state = in ? 4'b0010 : 4'b0001; // A -> B if in=1 else A
            state[1]: next_state = in ? 4'b0010 : 4'b0100; // B -> B if in=1 else C
            state[2]: next_state = in ? 4'b1000 : 4'b0001; // C -> D if in=1 else A
            state[3]: next_state = in ? 4'b0010 : 4'b0100; // D -> B if in=1 else C
            default:  next_state = 4'b0001;               // default to A on invalid state
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001; // Reset to A
        end else begin
            state <= next_state;
        end
    end

    // Moore output logic
    always @(*) begin
        out = state[3]; // Output 1 only in state D
    end

endmodule