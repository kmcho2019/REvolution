module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

// Define states
parameter A = 2'b00, B = 2'b01;

reg [1:0] state, nextState;
reg [2:0] counter; // 3-clock cycle counter
reg [1:0] w_count; // Count of w = 1 within 3 cycles

always @(*) begin
    case(state)
        A: begin
            if(s) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            nextState = B; // Stay in B
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= A;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        state <= nextState;
        if(state == A && s) begin
            // Reset counter and w_count when transitioning to B
            counter <= 1;
            w_count <= w;
        end else if(state == B) begin
            if(counter < 3) begin
                // Increment counter and update w_count if w = 1
                counter <= counter + 1;
                if(w) begin
                    w_count <= w_count + 1;
                end
            end else begin
                // Check condition for z = 1 and reset counter and w_count
                if(w_count == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
                counter <= 1; // Reset counter for next 3 cycles
                w_count <= w; // Reset w_count
            end
        end
    end
end

endmodule