module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    // Convert one-hot state to state index (0=A,1=B,2=C,3=D)
    function [1:0] state_to_index;
        input [3:0] st;
        begin
            case (st)
                4'b0001: state_to_index = 2'd0; // A
                4'b0010: state_to_index = 2'd1; // B
                4'b0100: state_to_index = 2'd2; // C
                4'b1000: state_to_index = 2'd3; // D
                default: state_to_index = 2'd0; // default to A
            endcase
        end
    endfunction

    reg [1:0] current_idx;
    reg [1:0] next_idx;

    always @(*) begin
        current_idx = state_to_index(state);

        case (current_idx)
            2'd0: next_idx = (in == 1'b0) ? 2'd0 : 2'd1; // A -> A or B
            2'd1: next_idx = (in == 1'b0) ? 2'd2 : 2'd1; // B -> C or B
            2'd2: next_idx = (in == 1'b0) ? 2'd0 : 2'd3; // C -> A or D
            2'd3: next_idx = (in == 1'b0) ? 2'd2 : 2'd1; // D -> C or B
            default: next_idx = 2'd0;
        endcase

        // Decode next_idx back to one-hot encoding
        case (next_idx)
            2'd0: next_state = 4'b0001; // A
            2'd1: next_state = 4'b0010; // B
            2'd2: next_state = 4'b0100; // C
            2'd3: next_state = 4'b1000; // D
            default: next_state = 4'b0001;
        endcase
    end

    // Output logic: output=1 only in state D (4'b1000)
    assign out = state[3];

endmodule