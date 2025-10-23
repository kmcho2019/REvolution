module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // State register: 2 bits to represent states A and B
reg [2:0] count; // Counter for w = 1 occurrences
reg [1:0] cycle; // Cycle counter to track the three cycles
reg z_next; // Next value of z

// Define states
parameter A = 2'b00, B = 2'b01;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        count <= 3'b000;
        cycle <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            A: begin
                if (s) begin
                    state <= B;
                    count <= 3'b000;
                    cycle <= 2'b00;
                end else begin
                    state <= A;
                end
            end
            B: begin
                // Count occurrences of w = 1
                if (w) begin
                    count <= count + 1;
                end
                // Increment cycle counter
                if (cycle == 2'b11) begin
                    cycle <= 2'b00;
                    // Determine z based on count
                    if (count == 3'b010) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    count <= 3'b000;
                end else begin
                    cycle <= cycle + 1;
                end
                state <= B; // Remain in state B
            end
        endcase
    end
end

endmodule