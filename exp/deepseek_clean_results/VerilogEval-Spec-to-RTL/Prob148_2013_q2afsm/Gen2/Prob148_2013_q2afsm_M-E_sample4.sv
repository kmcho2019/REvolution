module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;
    
    reg [3:0] current_state, next_state;
    reg [1:0] last_grant; // 00=none, 01=B, 10=C, 11=D
    
    // State transition logic with rotating priority
    always @(*) begin
        next_state = A; // Default to idle
        
        case (current_state)
            A: begin
                // Rotating priority based on last_grant
                if (r[0] && (last_grant != 2'b01)) next_state = B;
                else if (r[1] && (last_grant != 2'b10)) next_state = C;
                else if (r[2] && (last_grant != 2'b11)) next_state = D;
                else if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
            end
            
            B: next_state = (r[0] || (last_grant == 2'b01)) ? B : A;
            C: next_state = (r[1] || (last_grant == 2'b10)) ? C : A;
            D: next_state = (r[2] || (last_grant == 2'b11)) ? D : A;
        endcase
    end

    // State storage and last_grant tracking
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= A;
            last_grant <= 2'b00;
        end else begin
            current_state <= next_state;
            
            // Update last_grant when leaving a granted state
            if (current_state == B && next_state == A) last_grant <= 2'b01;
            else if (current_state == C && next_state == A) last_grant <= 2'b10;
            else if (current_state == D && next_state == A) last_grant <= 2'b11;
            else if (next_state == A) last_grant <= 2'b00;
        end
    end

    // Output logic - simple one-hot decoding
    assign g[0] = (current_state == B);
    assign g[1] = (current_state == C);
    assign g[2] = (current_state == D);

endmodule