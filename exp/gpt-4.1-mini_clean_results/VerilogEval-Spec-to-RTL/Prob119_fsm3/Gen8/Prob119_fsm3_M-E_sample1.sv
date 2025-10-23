module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);
    // SystemVerilog enum for states (requires a Verilog-2001/SystemVerilog compatible tool)
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    reg areset_sync1, areset_sync2; // synchronize async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            areset_sync1 <= 1'b1;
            areset_sync2 <= 1'b1;
        end else begin
            areset_sync1 <= 1'b0;
            areset_sync2 <= areset_sync1;
        end
    end

    state_t state, next_state;

    // Sequential block: state update and output register
    always @(posedge clk) begin
        if (areset_sync2) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output depends on next state for register
            out <= (next_state == D);
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

endmodule