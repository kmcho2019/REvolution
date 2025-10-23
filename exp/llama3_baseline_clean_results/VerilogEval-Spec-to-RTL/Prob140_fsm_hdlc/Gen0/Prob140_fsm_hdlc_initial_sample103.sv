module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [3:0] state; // States: 0 (reset/state after 0), 1 (after seeing one 1), 2 (after seeing two 1s), 3 (after seeing three 1s), 4 (after seeing four 1s), 5 (after seeing five 1s), 6 (after seeing six 1s)
reg disc_reg, flag_reg, err_reg; // Registers to hold the output values

always @(posedge clk or posedge reset) begin
    if(reset) begin // Reset to the initial state
        state <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0; // Default output values
        flag_reg <= 0;
        err_reg <= 0;

        case(state)
            0: begin // State after seeing 0 or reset
                if(in) begin
                    state <= 1; // Move to state 1 if input is 1
                end else begin
                    state <= 0; // Stay in state 0 if input is 0
                end
            end
            1: begin
                if(in) begin
                    state <= 2;
                end else begin
                    state <= 0;
                end
            end
            2: begin
                if(in) begin
                    state <= 3;
                end else begin
                    state <= 0;
                end
            end
            3: begin
                if(in) begin
                    state <= 4;
                end else begin
                    state <= 0;
                end
            end
            4: begin
                if(in) begin
                    state <= 5;
                end else begin
                    state <= 0;
                end
            end
            5: begin
                if(in) begin
                    state <= 6;
                    disc_reg <= 1; // Signal to discard the bit after five 1s
                end else begin
                    state <= 0;
                end
            end
            6: begin
                if(in) begin
                    state <= 6; // Stay in this state for any additional 1s, indicating an error
                    err_reg <= 1; // Error due to 7 or more consecutive 1s
                end else begin
                    state <= 0;
                    flag_reg <= 1; // Flag the start/end of a frame
                end
            end
        endcase
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule