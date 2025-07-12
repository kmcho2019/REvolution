module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state function
    function [2:0] f_next_state;
        input [2:0] curr_state;
        input w_in;
        begin
            case (curr_state)
                A: f_next_state = (w_in == 1'b0) ? B : A;
                B: f_next_state = (w_in == 1'b0) ? C : D;
                C: f_next_state = (w_in == 1'b0) ? E : D;
                D: f_next_state = (w_in == 1'b0) ? F : A;
                E: f_next_state = (w_in == 1'b0) ? E : D;
                F: f_next_state = (w_in == 1'b0) ? C : D;
                default: f_next_state = A; // default to A for safety
            endcase
        end
    endfunction

    assign next_state = f_next_state(state, w);

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    assign z = (state == E) || (state == F);

endmodule