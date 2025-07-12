module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B (not needed but easier for explanation), 2 and 3 are not used
reg [1:0] clock_counter; // Counts clock cycles since entering State B
reg [1:0] w_counter; // Counts the number of w = 1
reg z_reg; // Register for output z

// State encoding (for clarity, not necessary in a simple case like this)
localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= STATE_A;
        clock_counter <= 2'b00;
        w_counter <= 2'b00;
        z_reg <= 1'b0;
    end else begin
        case (state)
            STATE_A: begin
                if (s) begin
                    state <= STATE_B;
                    clock_counter <= 2'b01;
                    w_counter <= 2'b00;
                end else begin
                    state <= STATE_A;
                end
                z_reg <= 1'b0; // z should be 0 in State A
            end
            STATE_B: begin
                if (clock_counter == 2'b11) begin // After 3 clock cycles
                    if (w_counter == 2'b10) begin // Exactly 2 w = 1
                        z_reg <= 1'b1;
                    end else begin
                        z_reg <= 1'b0;
                    end
                    clock_counter <= 2'b01; // Reset counter for next sequence
                    w_counter <= 2'b00; // Reset w counter
                end else begin
                    if (w) begin
                        w_counter <= w_counter + 1;
                    end
                    clock_counter <= clock_counter + 1;
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule