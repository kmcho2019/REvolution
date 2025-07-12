module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state, next_state;
reg [2:0] counter_w; // Counter for w = 1 occurrences in 3 cycles

always @(*) begin
    case(state)
        2'b00: begin // State A
            if(s) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
            z = 0;
        end
        2'b01: begin // State B
            next_state = 2'b01; // Stay in B
            if(counter_w == 3'b111) begin // Check if counter_w is 7 (3'b111) to avoid accidental increment
                z = 1;
            end else begin
                z = 0;
            end
        end
        default: begin
            next_state = 2'b00;
            z = 0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        counter_w <= 3'b000;
    end else begin
        state <= next_state;
        if(state == 2'b00) begin
            counter_w <= 3'b000; // Reset counter_w in state A
        end else if(w) begin
            counter_w <= counter_w + 1; // Increment counter_w when w = 1 in state B
        end else if(counter_w[0] == 1'b1) begin // If counter_w has reached the end of its count
            counter_w <= 3'b100; // Reset the lower bits and set the highest bit
        end else begin
            counter_w <= {counter_w[1:0], 1'b0}; // Shift counter_w right when w = 0 in state B
        end
    end
end

endmodule