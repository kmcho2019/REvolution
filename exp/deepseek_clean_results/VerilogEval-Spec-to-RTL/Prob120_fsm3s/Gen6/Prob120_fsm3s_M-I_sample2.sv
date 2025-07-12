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

    // State registers
    reg [1:0] current_state, next_state;
    reg input_stable;
    reg prev_in;

    // Clock gating logic
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 1'b0;
            input_stable <= 1'b0;
        end else begin
            prev_in <= in;
            input_stable <= (in == prev_in);
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Output logic (registered for better timing)
    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b0;
        end else if (!input_stable) begin  // Only update when input changes
            out <= (current_state == D);
        end
    end

    // State register update with synchronous reset and clock gating
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else if (!input_stable) begin  // Only update when input changes
            current_state <= next_state;
        end
    end

endmodule