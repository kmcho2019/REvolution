module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Convert q values in the sequence {4,5,6,0,1,2,3} to indices 0..6
function integer q_to_idx;
    input [2:0] val;
    begin
        case (val)
            3'd4: q_to_idx = 0;
            3'd5: q_to_idx = 1;
            3'd6: q_to_idx = 2;
            3'd0: q_to_idx = 3;
            3'd1: q_to_idx = 4;
            3'd2: q_to_idx = 5;
            3'd3: q_to_idx = 6;
            default: q_to_idx = 0; // Recover to index 0 if invalid
        endcase
    end
endfunction

// Convert indices 0..6 back to q values in the sequence {4,5,6,0,1,2,3}
function [2:0] idx_to_q;
    input integer idx;
    begin
        case (idx % 7)
            0: idx_to_q = 3'd4;
            1: idx_to_q = 3'd5;
            2: idx_to_q = 3'd6;
            3: idx_to_q = 3'd0;
            4: idx_to_q = 3'd1;
            5: idx_to_q = 3'd2;
            6: idx_to_q = 3'd3;
            default: idx_to_q = 3'd4; // Defensive default
        endcase
    end
endfunction

function [2:0] next_state;
    input [2:0] curr_q;
    input a_in;
    integer idx;
    begin
        if (a_in) begin
            next_state = 3'd4; // hold at 4 if a=1
        end else begin
            idx = q_to_idx(curr_q);
            idx = (idx + 1) % 7; // modulo 7 increment
            next_state = idx_to_q(idx);
        end
    end
endfunction

always @(posedge clk) begin
    q <= next_state(q, a);
end

endmodule