module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

// State encoding
enum logic [1:0] {A, B} state, nextState;

// Counters and flags
reg [1:0] w_count;
reg [1:0] cycle_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
        w_count <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        state <= nextState;
        case(state)
            A: begin
                if (s) begin
                    nextState <= B;
                    w_count <= 2'b00;
                    cycle_count <= 2'b00;
                end else begin
                    nextState <= A;
                end
                z <= 1'b0;
            end
            B: begin
                cycle_count <= cycle_count + 1'b1;
                if (w) begin
                    w_count <= w_count + 1'b1;
                end
                if (cycle_count == 2'b11) begin // End of the 3-cycle window
                    if (w_count == 2'b10) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    nextState <= B; // Stay in state B
                    w_count <= 2'b00; // Reset w_count for the next window
                    cycle_count <= 2'b00; // Reset cycle_count for the next window
                end else begin
                    nextState <= B; // Continue in state B
                    z <= 1'b0; // z remains 0 until the end of the window
                end
            end
        endcase
    end
end

endmodule