module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // State A (2'b00) and State B (2'b01)
reg [1:0] count_w; // Counter for w = 1 occurrences
reg [1:0] cycle_count; // Counter for the current clock cycle
reg next_z; // Variable to hold the next value of z

// Initialize the state machine to state A
initial begin
    state = 2'b00;
    count_w = 2'b00;
    cycle_count = 2'b00;
    next_z = 1'b0;
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        count_w <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (s) begin
                    state <= 2'b01;
                    count_w <= 2'b00;
                    cycle_count <= 2'b01;
                end
            end
            2'b01: begin // State B
                if (w) begin
                    count_w <= count_w + 1'b1;
                end
                cycle_count <= cycle_count + 1'b1;
                if (cycle_count == 2'b11) begin
                    cycle_count <= 2'b01;
                    if (count_w == 2'b10) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    count_w <= 2'b00;
                end
            end
        endcase
    end
end

endmodule