module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Function to compute next state of q using modulo-7 counting starting at 4
function [2:0] next_state;
    input [2:0] curr_q;
    input a_in;
    reg [3:0] temp; // wider to hold intermediate sum
    begin
        if (a_in) begin
            // Hold q=4 when a=1
            next_state = 3'd4;
        end else begin
            // Map current q to modulo-7 domain by offsetting with 3 (4 mod 7 = 4)
            // Actually, sequence is 4->5->6->0->1->2->3->4...
            // Consider q modulo 7 with states remapped as:
            // q:4 -> 0 (mod count)
            // q:5 -> 1
            // q:6 -> 2
            // q:0 -> 3
            // q:1 -> 4
            // q:2 -> 5
            // q:3 -> 6
            // Then increment modulo 7 and map back
            
            // Mapping q to counter index: map_q = (q + 3) % 7
            temp = (curr_q + 3) % 7;
            // Increment modulo 7
            temp = (temp + 1) % 7;
            // Map back: q_next = (temp + 4) % 7
            next_state = (temp + 4) % 7;
        end
    end
endfunction

always @(posedge clk) begin
    q <= next_state(q, a);
end

endmodule