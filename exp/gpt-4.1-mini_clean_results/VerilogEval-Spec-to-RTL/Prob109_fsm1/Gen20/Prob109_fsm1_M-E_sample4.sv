module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State declarations for one-hot encoding
    // state_A = 1 means state A active; state_B = 1 means state B active
    reg state_A;
    reg state_B;

    // Next state signals
    reg next_state_A;
    reg next_state_B;

    // Next-state combinational logic
    always @(*) begin
        case ({state_A, state_B})
            2'b10: begin // Currently in state A
                if (in == 1'b0) begin
                    next_state_A = 1'b0;
                    next_state_B = 1'b1; // A --0--> B
                end else begin
                    next_state_A = 1'b1;
                    next_state_B = 1'b0; // A --1--> A
                end
            end
            2'b01: begin // Currently in state B
                if (in == 1'b0) begin
                    next_state_A = 1'b1;
                    next_state_B = 1'b0; // B --0--> A
                end else begin
                    next_state_A = 1'b0;
                    next_state_B = 1'b1; // B --1--> B
                end
            end
            default: begin
                // Safety fallback: default to state B
                next_state_A = 1'b0;
                next_state_B = 1'b1;
            end
        endcase
    end

    // State register with asynchronous reset to state B
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

    // Moore machine output: 1 in B, 0 in A
    assign out = state_B;

endmodule