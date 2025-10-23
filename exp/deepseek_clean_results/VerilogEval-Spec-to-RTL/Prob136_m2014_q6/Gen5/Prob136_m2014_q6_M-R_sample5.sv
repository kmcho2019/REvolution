module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding using localparam (same Gray coding)
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] current_state, next_state;

    // Combinational next state logic
    function [2:0] get_next_state;
        input [2:0] state;
        input w;
        begin
            case (state)
                A: get_next_state = w ? A : B;
                B: get_next_state = w ? D : C;
                C: get_next_state = w ? D : E;
                D: get_next_state = w ? A : F;
                E: get_next_state = w ? D : E;
                F: get_next_state = w ? D : C;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Continuous assignments
    assign next_state = get_next_state(current_state, w);
    assign z = current_state[2];  // Output is MSB of state (1 for E/F)

endmodule