module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter CHECKING = 2'b10;

reg [1:0] state, next_state;
reg [1:0] counter; // Counter for clock cycles
reg [1:0] w_count; // Counter for w = 1 occurrences
reg z_reg;

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
            z_reg = 0;
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
                    z_reg = 1;
                end else begin
                    z_reg = 0;
                end
                counter = 0; // Reset counter
                w_count = 0; // Reset w_count
            end
        end
        default: begin
            next_state = A;
            z_reg = 0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= A;
        z <= 0;
    end else begin
        state <= next_state;
        z <= z_reg;
    end
end

endmodule