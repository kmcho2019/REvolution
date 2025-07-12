module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam A = 0, B = 1, C = 2, D = 3;

reg [1:0] state, next_state;
reg [1:0] seq_cnt;    // Counts 1-0-1 sequence progress
reg [1:0] timeout;    // Counts cycles waiting for y

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        seq_cnt <= 0;
        timeout <= 0;
        f <= 0;
        g <= 0;
    end
    else begin
        state <= next_state;
        
        // Sequence detection counter
        if (state == B) begin
            if (x && seq_cnt == 0) seq_cnt <= 1;
            else if (!x && seq_cnt == 1) seq_cnt <= 2;
            else if (x && seq_cnt == 2) seq_cnt <= 3;
            else seq_cnt <= 0;
        end
        
        // Timeout counter
        if (state == D && !y && timeout < 2)
            timeout <= timeout + 1;
    end
end

always @(*) begin
    case (state)
        A: next_state = resetn ? B : A;
        B: next_state = (seq_cnt == 3) ? D : B;
        D: next_state = D; // Permanent state
        default: next_state = A;
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        f <= 0;
        g <= 0;
    end
    else begin
        // Pulse f for one cycle after reset
        f <= (state == A && resetn);
        
        // Set g when sequence detected
        if (state == B && seq_cnt == 3)
            g <= 1;
            
        // Clear g if timeout reached without y
        if (state == D && timeout == 2 && !y)
            g <= 0;
    end
end

endmodule