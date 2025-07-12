module TopModule(
    input  [5:0] y,  // one-hot encoded current state
    input        w,  // input signal
    output       Y1, // next input for flip-flop y[1]
    output       Y3  // next input for flip-flop y[3]
);

    // Function to convert one-hot to binary index (0 to 5)
    function [2:0] onehot_to_bin;
        input [5:0] onehot;
        integer i;
        begin
            onehot_to_bin = 3'd0;
            for(i=0; i<6; i=i+1) begin
                if(onehot[i]) onehot_to_bin = i[2:0];
            end
        end
    endfunction

    // Function to convert binary index (0 to 5) to one-hot 6-bit vector
    function [5:0] bin_to_onehot;
        input [2:0] bin;
        begin
            bin_to_onehot = 6'b000000;
            if(bin < 6)
                bin_to_onehot = 6'b1 << bin;
        end
    endfunction

    // Current state index
    wire [2:0] curr_state = onehot_to_bin(y);
    reg  [2:0] next_state;

    always @(*) begin
        case(curr_state)
            3'd0: // A
                if(w) next_state = 3'd1; else next_state = 3'd0; // B or A
            3'd1: // B
                if(w) next_state = 3'd2; else next_state = 3'd3; // C or D
            3'd2: // C
                if(w) next_state = 3'd4; else next_state = 3'd3; // E or D
            3'd3: // D
                if(w) next_state = 3'd5; else next_state = 3'd0; // F or A
            3'd4: // E
                if(w) next_state = 3'd4; else next_state = 3'd3; // E or D
            3'd5: // F
                if(w) next_state = 3'd2; else next_state = 3'd3; // C or D
            default:
                next_state = 3'd0; // default to A if invalid
        endcase
    end

    wire [5:0] next_onehot = bin_to_onehot(next_state);

    // Outputs Y1 and Y3 correspond to inputs of flip-flops y[1] and y[3] respectively
    assign Y1 = next_onehot[1];
    assign Y3 = next_onehot[3];

endmodule