module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // State machine to track the sequence
reg [3:0] count; // Counter for consecutive ones
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset state
        count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;

        case (state)
            0: begin // Initial state
                if (in) begin
                    count <= 1;
                    state <= 1;
                end
            end
            1: begin // Counting consecutive ones
                if (in) begin
                    count <= count + 1;
                    if (count == 5) begin
                        state <= 2; // Check for discard or flag
                    end else if (count >= 7) begin
                        state <= 3; // Error state
                    end
                end else begin
                    count <= 0;
                    state <= 0;
                end
            end
            2: begin // Check for discard or flag
                if (in) begin
                    state <= 3; // Error state
                end else begin
                    state <= 4; // Flag state
                end
            end
            3: begin // Error state
                err_reg <= 1;
                if (!in) begin
                    count <= 0;
                    state <= 0;
                end
            end
            4: begin // Flag state
                flag_reg <= 1;
                count <= 0;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase

        // Check for discard condition
        if (state == 1 && count == 5 && !in) begin
            disc_reg <= 1;
            count <= 0;
            state <= 0;
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule