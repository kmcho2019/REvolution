module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // States: 0 - A, 1 - B
reg [1:0] counter; // Counter for the 3-cycle window
reg w_count; // Counter for w=1 instances within the window
reg z_next; // Next value of z

// Initialize state and counters
initial begin
    state = 0; // Start in state A
    counter = 0;
    w_count = 0;
    z_next = 0;
end

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state A
        counter <= 0;
        w_count <= 0;
        z_next <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // Move to state B
                    counter <= 1; // Start the 3-cycle counter
                    w_count <= w; // Initialize w_count based on current w
                end else begin
                    state <= 0; // Stay in state A
                end
            end
            1: begin // State B
                if (counter < 3) begin
                    counter <= counter + 1; // Increment cycle counter
                    w_count <= w_count + w; // Increment w_count if w=1
                end else begin
                    counter <= 1; // Reset cycle counter
                    z_next <= (w_count == 2); // Set z_next based on w_count
                    w_count <= w; // Reset w_count, starting with current w
                end
            end
        endcase
    end
end

// Assign z based on z_next
always @(posedge clk) begin
    if (reset) begin
        z <= 0;
    end else if (state == 1 && counter == 1) begin
        z <= z_next; // Update z at the start of each window
    end
end

endmodule