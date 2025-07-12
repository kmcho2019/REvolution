module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // Use typedef enum for states for better readability
    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;

    // Function to compute next state based on current state and input w
    function state_t get_next_state(input state_t curr_state, input logic w_in);
        begin
            case (curr_state)
                A: get_next_state = w_in ? B : A;
                B: get_next_state = w_in ? C : D;
                C: get_next_state = w_in ? E : D;
                D: get_next_state = w_in ? F : A;
                E: get_next_state = w_in ? E : D;
                F: get_next_state = w_in ? C : D;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic using the function
    always @(*) begin
        next_state = get_next_state(state, w);
    end

    // Output logic: z=1 for states E and F, else 0
    always @(*) begin
        case (state)
            E, F: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule