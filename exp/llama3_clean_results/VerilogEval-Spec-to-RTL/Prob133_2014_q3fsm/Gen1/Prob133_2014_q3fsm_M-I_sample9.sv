module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;

reg [1:0] state, next_state;
reg [1:0] counter; // Counter for clock cycles
reg [1:0] w_count; // Counter for w = 1 occurrences

always @(*) begin
    case(state)
        A: begin
            if(s) begin
                next_state = B;
                counter = 0;
                w_count = 0;
            end else begin
                next_state = A;
            end
            z = 0;
        end
        B: begin
            next_state = B; // Stay in B
            if(counter < 3) begin
                counter = counter + 1;
                if(w) begin
                    w_count = w_count + 1;
                end
            end else begin // Counter reached 3
                if(w_count == 2) begin // Set z to 1 if exactly two w = 1
                    z = 1;
                end else begin
                    z = 0;
                end
                counter = 0; // Reset counter
                w_count = 0; // Reset w_count
            end
        end
        default: begin
            next_state = A;
            z = 0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule