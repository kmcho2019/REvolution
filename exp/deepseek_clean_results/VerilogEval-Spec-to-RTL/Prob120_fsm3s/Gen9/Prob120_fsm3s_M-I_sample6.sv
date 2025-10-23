module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Gray code state encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter D = 2'b11;
    parameter C = 2'b10;

    // State registers with low-power synthesis attribute
    (* syn_preserve = 1, syn_allow_retiming = 0 *)
    reg [1:0] current_state, next_state;

    // Clock gating signal
    reg input_changed;
    reg last_in;

    // Track input changes for clock gating
    always @(posedge clk) begin
        if (reset)
            last_in <= 1'b0;
        else
            last_in <= in;
    end

    assign input_changed = (in != last_in);

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Simplified output logic with direct state comparison
    always @(*) begin
        out = (current_state == D);
    end

    // State register update with synchronous reset and clock gating
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else if (input_changed) begin
            current_state <= next_state;
        end
    end

endmodule