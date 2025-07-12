module TopModule(clk, reset, w, z);
    input clk, reset, w;
    output z;
    reg [2:0] state, next_state;

    // State encoding: A = 0, B = 1, C = 2, D = 3, E = 4, F = 5
    // Determine next state
    always @(state, w) begin
        case(state)
            0: next_state = w ? 1 : 0;
            1: next_state = w ? 2 : 3;
            2: next_state = w ? 4 : 3;
            3: next_state = w ? 5 : 0;
            4: next_state = w ? 4 : 3;
            5: next_state = w ? 2 : 3;
            default: next_state = 0;
        endcase
    end

    // State flip-flops
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign z = (state == 4 || state == 5);

endmodule