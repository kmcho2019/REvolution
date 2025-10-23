module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // States: 0 - A, 1 - B
reg [1:0] counter; // Counter for clock cycles in state B
reg       w_count; // Flag to count w = 1 conditions
reg       prev_w;  // Previous value of w for edge detection

initial begin
    state = 0; // Initialize state to A
    counter = 0;
    w_count = 0;
    prev_w = 0;
    z = 0;
end

always @(posedge clk) begin
    if (reset) begin
        state = 0; // Reset to state A
        counter = 0;
        w_count = 0;
        prev_w = 0;
        z = 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state = 1; // Move to state B
                end
            end
            1: begin // State B
                if (counter == 0 && w) begin
                    w_count = 1;
                end else if (counter == 1 && w) begin
                    w_count = 2;
                end else if (counter == 2 && w) begin
                    w_count = 3;
                end
                counter = counter + 1;
                if (counter == 3) begin
                    if (w_count == 2) begin
                        z = 1;
                    end else begin
                        z = 0;
                    end
                    counter = 0;
                    w_count = 0;
                end
            end
        endcase
    end
end

endmodule